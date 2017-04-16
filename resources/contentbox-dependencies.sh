apt-get update
apt-get install --assume-yes rsync zip unzip

# Run the full contentbox install to pre-seed everything
cd ${APP_DIR} && box install
ls -la

cd $BUILD_DIR
ls -la

