[[Go back]](README.md)

## 2 - Timelapse to video with ffmpeg

#### 2.1 - General commands

No crop (add black bars where needed) - No upscaling
```
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale='min(3840,iw)':min'(2160,ih)':force_original_aspect_ratio=decrease,pad=3840:2160:(ow-iw)/2:(oh-ih)/2" 4k-30fps.mp4
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale='min(2560,iw)':min'(1440,ih)':force_original_aspect_ratio=decrease,pad=2560:1440:(ow-iw)/2:(oh-ih)/2" 1440p-30fps.mp4
```

Cropping
```
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=3840:2160:force_original_aspect_ratio=increase,crop=3840:2160" 4k-30fps-crop.mp4
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -crf 20 -pix_fmt yuv420p -tune film -vf "scale=2560:1440:force_original_aspect_ratio=increase,crop=2560:1440" 1440p-30fps-crop.mp4
```

Other encoding profile, more contrast (may not work on every player)
```
ffmpeg -r 30 -pattern_type glob -i '*.JPG' -vcodec libx264 -profile:v high422 -crf 20 -tune film -vf "scale='min(3840,iw)':min'(2160,ih)':force_original_aspect_ratio=decrease,pad=3840:2160:(ow-iw)/2:(oh-ih)/2" 4k-30fps-high422.mp4
```

<br/>

#### 2.2 - Options explained

| Command | Meaning |
|---------|---------|
| `-r 30` | Output frame rate |
| `-pattern_type glob -i '*.JPG'` | All JPG files in the current directory |
| `-vcodec libx264` | H.264 encoding (mp4) |
| `-crf 20` | Constant Rate Factor (lower = better, anything below 18 might not be visually better, 23 default) 20 would be good since YouTube re-encodes the video again |
| `-pix_fmt yuv420p` | Enable YUV planar color space with 4:2:0 chroma subsampling for H.264 video (so the output file works in QuickTime and most other players) |
| `-tune film` | Intended for high-bitrate/high-quality movie content. Lower deblocking is used here. |

<br/>

**Other** `-tune` **options:**
- `-tune grain` This should be used for material that is already grainy. Here, the grain won't be filtered out as much.
- `-tune fastdecode` Disables CABAC and the in-loop deblocking filter to allow for faster decoding on devices with lower computational power.
- `-tune zerolatency` Optimization for fast encoding and low latency streaming.

<br/>

**Unused options:**
- `-preset veryfast` Encoding speed. A slower preset provides better compression (quality per file size) but is slower. Use the slowest that you have patience for.
  - Possibilities: `ultrafast`, `superfast`, `veryfast`, `faster`, `fast`, `medium` (default), `slow`, `slower`, `veryslow`.
