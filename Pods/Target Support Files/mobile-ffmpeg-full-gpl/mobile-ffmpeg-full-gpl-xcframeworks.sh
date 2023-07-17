#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR


# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")


variant_for_slice()
{
  case "$1" in
  "mobileffmpeg.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "mobileffmpeg.xcframework/ios-arm64")
    echo ""
    ;;
  "mobileffmpeg.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libavcodec.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libavcodec.xcframework/ios-arm64")
    echo ""
    ;;
  "libavcodec.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libavdevice.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libavdevice.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libavdevice.xcframework/ios-arm64")
    echo ""
    ;;
  "libavfilter.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libavfilter.xcframework/ios-arm64")
    echo ""
    ;;
  "libavfilter.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libavformat.xcframework/ios-arm64")
    echo ""
    ;;
  "libavformat.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libavformat.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libavutil.xcframework/ios-arm64")
    echo ""
    ;;
  "libavutil.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libavutil.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libswresample.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libswresample.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libswresample.xcframework/ios-arm64")
    echo ""
    ;;
  "libswscale.xcframework/ios-arm64")
    echo ""
    ;;
  "libswscale.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libswscale.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "expat.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "expat.xcframework/ios-arm64")
    echo ""
    ;;
  "expat.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "fontconfig.xcframework/ios-arm64")
    echo ""
    ;;
  "fontconfig.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "fontconfig.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "freetype.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "freetype.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "freetype.xcframework/ios-arm64")
    echo ""
    ;;
  "fribidi.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "fribidi.xcframework/ios-arm64")
    echo ""
    ;;
  "fribidi.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "giflib.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "giflib.xcframework/ios-arm64")
    echo ""
    ;;
  "giflib.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "gmp.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "gmp.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "gmp.xcframework/ios-arm64")
    echo ""
    ;;
  "gnutls.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "gnutls.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "gnutls.xcframework/ios-arm64")
    echo ""
    ;;
  "jpeg.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "jpeg.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "jpeg.xcframework/ios-arm64")
    echo ""
    ;;
  "kvazaar.xcframework/ios-arm64")
    echo ""
    ;;
  "kvazaar.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "kvazaar.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "lame.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "lame.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "lame.xcframework/ios-arm64")
    echo ""
    ;;
  "libaom.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libaom.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libaom.xcframework/ios-arm64")
    echo ""
    ;;
  "libass.xcframework/ios-arm64")
    echo ""
    ;;
  "libass.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libass.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libhogweed.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libhogweed.xcframework/ios-arm64")
    echo ""
    ;;
  "libhogweed.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libilbc.xcframework/ios-arm64")
    echo ""
    ;;
  "libilbc.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libilbc.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libnettle.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libnettle.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libnettle.xcframework/ios-arm64")
    echo ""
    ;;
  "libogg.xcframework/ios-arm64")
    echo ""
    ;;
  "libogg.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libogg.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libopencore-amrnb.xcframework/ios-arm64")
    echo ""
    ;;
  "libopencore-amrnb.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libopencore-amrnb.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libpng.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libpng.xcframework/ios-arm64")
    echo ""
    ;;
  "libpng.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libsndfile.xcframework/ios-arm64")
    echo ""
    ;;
  "libsndfile.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libsndfile.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libtheora.xcframework/ios-arm64")
    echo ""
    ;;
  "libtheora.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libtheora.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libtheoradec.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libtheoradec.xcframework/ios-arm64")
    echo ""
    ;;
  "libtheoradec.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libtheoraenc.xcframework/ios-arm64")
    echo ""
    ;;
  "libtheoraenc.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libtheoraenc.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libvorbis.xcframework/ios-arm64")
    echo ""
    ;;
  "libvorbis.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libvorbis.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libvorbisenc.xcframework/ios-arm64")
    echo ""
    ;;
  "libvorbisenc.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libvorbisenc.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libvorbisfile.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libvorbisfile.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libvorbisfile.xcframework/ios-arm64")
    echo ""
    ;;
  "libvpx.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libvpx.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libvpx.xcframework/ios-arm64")
    echo ""
    ;;
  "libwebp.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libwebp.xcframework/ios-arm64")
    echo ""
    ;;
  "libwebp.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libwebpmux.xcframework/ios-arm64")
    echo ""
    ;;
  "libwebpmux.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libwebpmux.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libwebpdemux.xcframework/ios-arm64")
    echo ""
    ;;
  "libwebpdemux.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libwebpdemux.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libxml2.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libxml2.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "libxml2.xcframework/ios-arm64")
    echo ""
    ;;
  "opus.xcframework/ios-arm64")
    echo ""
    ;;
  "opus.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "opus.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "shine.xcframework/ios-arm64")
    echo ""
    ;;
  "shine.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "shine.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "snappy.xcframework/ios-arm64")
    echo ""
    ;;
  "snappy.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "snappy.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "soxr.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "soxr.xcframework/ios-arm64")
    echo ""
    ;;
  "soxr.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "speex.xcframework/ios-arm64")
    echo ""
    ;;
  "speex.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "speex.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "tiff.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "tiff.xcframework/ios-arm64")
    echo ""
    ;;
  "tiff.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "twolame.xcframework/ios-arm64")
    echo ""
    ;;
  "twolame.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "twolame.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "vo-amrwbenc.xcframework/ios-arm64")
    echo ""
    ;;
  "vo-amrwbenc.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "vo-amrwbenc.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "wavpack.xcframework/ios-arm64")
    echo ""
    ;;
  "wavpack.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "wavpack.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libvidstab.xcframework/ios-arm64")
    echo ""
    ;;
  "libvidstab.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "libvidstab.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "x264.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "x264.xcframework/ios-arm64")
    echo ""
    ;;
  "x264.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "x265.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "x265.xcframework/ios-arm64")
    echo ""
    ;;
  "x265.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  "xvidcore.xcframework/ios-arm64")
    echo ""
    ;;
  "xvidcore.xcframework/ios-x86_64-maccatalyst")
    echo "maccatalyst"
    ;;
  "xvidcore.xcframework/ios-x86_64-simulator")
    echo "simulator"
    ;;
  esac
}

archs_for_slice()
{
  case "$1" in
  "mobileffmpeg.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "mobileffmpeg.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "mobileffmpeg.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libavcodec.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libavcodec.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libavcodec.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libavdevice.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libavdevice.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libavdevice.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libavfilter.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libavfilter.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libavfilter.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libavformat.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libavformat.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libavformat.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libavutil.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libavutil.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libavutil.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libswresample.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libswresample.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libswresample.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libswscale.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libswscale.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libswscale.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "expat.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "expat.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "expat.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "fontconfig.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "fontconfig.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "fontconfig.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "freetype.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "freetype.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "freetype.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "fribidi.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "fribidi.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "fribidi.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "giflib.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "giflib.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "giflib.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "gmp.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "gmp.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "gmp.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "gnutls.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "gnutls.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "gnutls.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "jpeg.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "jpeg.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "jpeg.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "kvazaar.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "kvazaar.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "kvazaar.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "lame.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "lame.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "lame.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libaom.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libaom.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libaom.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libass.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libass.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libass.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libhogweed.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libhogweed.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libhogweed.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libilbc.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libilbc.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libilbc.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libnettle.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libnettle.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libnettle.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libogg.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libogg.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libogg.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libopencore-amrnb.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libopencore-amrnb.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libopencore-amrnb.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libpng.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libpng.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libpng.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libsndfile.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libsndfile.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libsndfile.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libtheora.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libtheora.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libtheora.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libtheoradec.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libtheoradec.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libtheoradec.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libtheoraenc.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libtheoraenc.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libtheoraenc.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libvorbis.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libvorbis.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libvorbis.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libvorbisenc.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libvorbisenc.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libvorbisenc.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libvorbisfile.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libvorbisfile.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libvorbisfile.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libvpx.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libvpx.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libvpx.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libwebp.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libwebp.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libwebp.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libwebpmux.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libwebpmux.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libwebpmux.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libwebpdemux.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libwebpdemux.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libwebpdemux.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libxml2.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libxml2.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "libxml2.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "opus.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "opus.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "opus.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "shine.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "shine.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "shine.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "snappy.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "snappy.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "snappy.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "soxr.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "soxr.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "soxr.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "speex.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "speex.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "speex.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "tiff.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "tiff.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "tiff.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "twolame.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "twolame.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "twolame.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "vo-amrwbenc.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "vo-amrwbenc.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "vo-amrwbenc.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "wavpack.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "wavpack.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "wavpack.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libvidstab.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "libvidstab.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "libvidstab.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "x264.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "x264.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "x264.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "x265.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "x265.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "x265.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  "xvidcore.xcframework/ios-arm64")
    echo "arm64"
    ;;
  "xvidcore.xcframework/ios-x86_64-maccatalyst")
    echo "x86_64"
    ;;
  "xvidcore.xcframework/ios-x86_64-simulator")
    echo "x86_64"
    ;;
  esac
}

copy_dir()
{
  local source="$1"
  local destination="$2"

  # Use filter instead of exclude so missing patterns don't throw errors.
  echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" \"${source}*\" \"${destination}\""
  rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" "${source}"/* "${destination}"
}

SELECT_SLICE_RETVAL=""

select_slice() {
  local xcframework_name="$1"
  xcframework_name="${xcframework_name##*/}"
  local paths=("${@:2}")
  # Locate the correct slice of the .xcframework for the current architectures
  local target_path=""

  # Split archs on space so we can find a slice that has all the needed archs
  local target_archs=$(echo $ARCHS | tr " " "\n")

  local target_variant=""
  if [[ "$PLATFORM_NAME" == *"simulator" ]]; then
    target_variant="simulator"
  fi
  if [[ ! -z ${EFFECTIVE_PLATFORM_NAME+x} && "$EFFECTIVE_PLATFORM_NAME" == *"maccatalyst" ]]; then
    target_variant="maccatalyst"
  fi
  for i in ${!paths[@]}; do
    local matched_all_archs="1"
    local slice_archs="$(archs_for_slice "${xcframework_name}/${paths[$i]}")"
    local slice_variant="$(variant_for_slice "${xcframework_name}/${paths[$i]}")"
    for target_arch in $target_archs; do
      if ! [[ "${slice_variant}" == "$target_variant" ]]; then
        matched_all_archs="0"
        break
      fi

      if ! echo "${slice_archs}" | tr " " "\n" | grep -F -q -x "$target_arch"; then
        matched_all_archs="0"
        break
      fi
    done

    if [[ "$matched_all_archs" == "1" ]]; then
      # Found a matching slice
      echo "Selected xcframework slice ${paths[$i]}"
      SELECT_SLICE_RETVAL=${paths[$i]}
      break
    fi
  done
}

install_xcframework() {
  local basepath="$1"
  local name="$2"
  local package_type="$3"
  local paths=("${@:4}")

  # Locate the correct slice of the .xcframework for the current architectures
  select_slice "${basepath}" "${paths[@]}"
  local target_path="$SELECT_SLICE_RETVAL"
  if [[ -z "$target_path" ]]; then
    echo "warning: [CP] $(basename ${basepath}): Unable to find matching slice in '${paths[@]}' for the current build architectures ($ARCHS) and platform (${EFFECTIVE_PLATFORM_NAME-${PLATFORM_NAME}})."
    return
  fi
  local source="$basepath/$target_path"

  local destination="${PODS_XCFRAMEWORKS_BUILD_DIR}/${name}"

  if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
  fi

  copy_dir "$source/" "$destination"
  echo "Copied $source to $destination"
}

install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/mobileffmpeg.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libavcodec.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libavdevice.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libavfilter.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libavformat.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libavutil.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libswresample.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libswscale.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/expat.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/fontconfig.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/freetype.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/fribidi.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/giflib.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/gmp.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/gnutls.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/jpeg.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/kvazaar.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/lame.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libaom.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libass.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libhogweed.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libilbc.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libnettle.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libogg.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libopencore-amrnb.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libpng.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libsndfile.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libtheora.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libtheoradec.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libtheoraenc.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libvorbis.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libvorbisenc.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libvorbisfile.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libvpx.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libwebp.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libwebpmux.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libwebpdemux.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libxml2.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/opus.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/shine.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/snappy.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/soxr.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/speex.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/tiff.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/twolame.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/vo-amrwbenc.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/wavpack.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/libvidstab.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/x264.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/x265.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full-gpl/xvidcore.xcframework" "mobile-ffmpeg-full-gpl" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"

