apt-get install --assume-yes rsync

cd $BUILD_DIR
ls -la

rsync -av $BUILD_DIR/express/ $APP_DIR/

