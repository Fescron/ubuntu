[[Go back]](README.md)

## Table of contents

- [2 - Timelapse to video with ffmpeg](2-timelapse-ffmpeg.md)
  - [2.1 - General commands](2-timelapse-ffmpeg.md#21---general-commands)
  - [2.2 - Options explained](2-timelapse-ffmpeg.md#22---options-explained)
  - [2.3 - Other useful commands](2-timelapse-ffmpeg.md#23---other-useful-commands)

------

## 2 - Timelapse to video with ffmpeg

#### 2.1 - General commands

No crop (add black bars where needed) - No upscaling
```
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale='min(3840,iw)':min'(2160,ih)':force_original_aspect_ratio=decrease,pad=3840:2160:(ow-iw)/2:(oh-ih)/2" 4k-30fps.mp4
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale='min(2560,iw)':min'(1440,ih)':force_original_aspect_ratio=decrease,pad=2560:1440:(ow-iw)/2:(oh-ih)/2" 1440p-30fps.mp4
```

Cropping from center
```
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=3840:2160:force_original_aspect_ratio=increase,crop=3840:2160" 4k-30fps-crop.mp4
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=2560:1440:force_original_aspect_ratio=increase,crop=2560:1440" 1440p-30fps-crop.mp4
```

Cropping from center (Instagram)
```
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=1080:1080:force_original_aspect_ratio=increase,crop=1080:1080" insta-1x1-30fps-crop.mp4
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=1080:1350:force_original_aspect_ratio=increase,crop=1080:1350" insta-4x5-30fps-crop.mp4
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=1080:566:force_original_aspect_ratio=increase,crop=1080:566" insta-5x4-30fps-crop.mp4
```

Cropping from bottom
```
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=3840:2160:force_original_aspect_ratio=increase,crop=3840:2160:0:oh" 4k-30fps-crop-bottom.mp4
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=2560:1440:force_original_aspect_ratio=increase,crop=2560:1440:0:oh" 1440p-30fps-crop-bottom.mp4
```

Cropping from top
```
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=3840:2160:force_original_aspect_ratio=increase,crop=3840:2160:0:0" 4k-30fps-crop-top.mp4
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=2560:1440:force_original_aspect_ratio=increase,crop=2560:1440:0:0" 1440p-30fps-crop-top.mp4
```

Adding a watermark
```
ffmpeg -i insta-4x5-30fps-crop.mp4 -r 30 -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "drawtext=text='@brecht.ve':x=10:y=H-th-13:fontfile='/home/brecht/.fonts/BebasNeue Light.otf':fontsize=35:fontcolor=white@0.65" insta-4x5-30fps-crop-watermark.mp4
```

Other encoding profile, more contrast (may not work on every player)
```
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -profile:v high422 -crf 20 -tune film -vf "scale='min(3840,iw)':min'(2160,ih)':force_original_aspect_ratio=decrease,pad=3840:2160:(ow-iw)/2:(oh-ih)/2" 4k-30fps-high422.mp4
```

Select all images in all subdirectories (recursively), don't crop/enlarge
```
ffmpeg -r 30 -pattern_type glob -i '**/*.jpg' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film timelapse-30fps.mp4
```

Select all images in (sub)directories with specific names (dates), don't crop/enlarge, increase framerate using `minterpolate` filter from 30 to 60fps for smoother looking timelapse
```
ffmpeg -r 30 -pattern_type glob -i '2020-04-{02,03,04}/{07,08,09}/*.jpg' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "minterpolate=fps=60" timelapse-blurred.mp4
```

<br/>

#### 2.2 - Options explained

| Command | Meaning |
|---------|---------|
| `-r 30` | Output frame rate |
| `-pattern_type glob -i '*.JPG'` | All JPG files in the current directory |
| `'*/*.JPG'` | All JPG files from all directories, one level down from the current directory |
| `'**/*.JPG'` |  All JPG files from all directories, all levels down from the current directory (recursively) |
| `-vcodec libx264` | H.264 encoding (mp4) |
| `-crf 20` | Constant Rate Factor (lower = better, anything below 18 might not be visually better, 23 default) 20 would be good since YouTube re-encodes the video again |
| `-pix_fmt yuv420p` | Enable YUV planar color space with 4:2:0 chroma subsampling for H.264 video (so the output file works in QuickTime and most other players) |
| `-tune film` | Intended for high-bitrate/high-quality movie content. Lower deblocking is used here. |
| `-vf "minterpolate=fps=60"` | Use `minterpolate` videofilter to interpolate images and make a smoother video. **Slow because only uses single CPU core!** |


<br/>

**Other** `-tune` **options:**
- `-tune grain` This should be used for material that is already grainy. Here, the grain won't be filtered out as much.
- `-tune fastdecode` Disables CABAC and the in-loop deblocking filter to allow for faster decoding on devices with lower computational power.
- `-tune zerolatency` Optimization for fast encoding and low latency streaming.

<br/>

**Unused options:**
- `-preset veryfast` Encoding speed. A slower preset provides better compression (quality per file size) but is slower. Use the slowest that you have patience for.
  - Possibilities: `ultrafast`, `superfast`, `veryfast`, `faster`, `fast`, `medium` (default), `slow`, `slower`, `veryslow`.

<br/>

#### 2.3 - Other useful commands

Bulk convert JPGs to 1920x1080, centered
```
convert input.jpg -resize '1920x1080^' -gravity center -crop '1920x1080+0+0' output.jpg
```

Renaming
```
mkdir renamed; num=0; for f in $(ls -tr); do cp -p "$f" renamed/IMG_$(printf "%04d" $num).JPG; printf "\n\r$num"; num=$((num+1)); done
```
