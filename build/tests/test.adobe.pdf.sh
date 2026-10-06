#!/bin/bash
# Verifies Adobe ColdFusion PDF (cfdocument) and image (cfimage) rendering, which depend on native OS libraries
set -e

if [[ $BOX_SERVER_APP_CFENGINE != *adobe* ]]; then
	echo "Not an Adobe engine image - skipping PDF/image rendering checks"
	exit 0
fi

cd "${APP_DIR}"
checkDir=$(mktemp -d)
trap 'rm -rf "$checkDir" "$APP_DIR/adobe-render-check.cfm"' EXIT

cat > "$APP_DIR/adobe-render-check.cfm" <<'CFM'
<cfscript>
	switch ( url.type ) {
		case "pdf":
			cfdocument( format="pdf" ) { writeOutput( "<h1>PDF rendering check</h1><p>Fonts and layout</p>" ); }
			break;
		case "image":
			img = imageNew( "", 240, 60 );
			imageDrawText( img, "Image rendering check", 10, 30 );
			cfimage( action="writeToBrowser", source=img, format="png" );
			break;
		case "chart":
			cfchart( format="png", chartWidth=300, chartHeight=200 ) {
				cfchartseries( type="bar" ) {
					cfchartdata( item="a", value=1 );
					cfchartdata( item="b", value=2 );
				}
			}
			break;
	}
</cfscript>
CFM

export IMAGE_TESTING_IN_PROGRESS=true
# cfdocument and cfimage need these optional Adobe packages; run via bash because the engine's scripts are not executable
serverHome=${BOX_SERVER_APP_SERVERHOMEDIRECTORY:-$LIB_DIR/serverHome}
bash "$serverHome/WEB-INF/cfusion/bin/cfpm.sh" install document,image
runOutput="$( ${BUILD_DIR}/run.sh )"
printf '%s\n' "${runOutput}"
$BUILD_DIR/tests/test.up.sh

checkRender () {
	local type=$1 magic=$2 output="$checkDir/$1.out"
	if ! curl --fail --silent --show-error --max-time 180 "http://127.0.0.1:${PORT}/adobe-render-check.cfm?type=${type}" -o "$output"; then
		echo "Adobe ${type} rendering request failed"
		box server log || true
		exit 1
	fi
	if ! grep -aq -- "$magic" "$output"; then
		echo "Adobe ${type} rendering did not return the expected output:"
		head -c 2000 "$output"
		box server log || true
		exit 1
	fi
	echo "Adobe ${type} rendering check passed"
}

checkRender pdf '%PDF-'
# writeToBrowser returns an HTML img tag with the PNG data embedded
checkRender image '<img'
checkRender chart 'PNG'

box server stop
