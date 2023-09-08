YouTube: 18.31.40  

Install [Vanced Microg](https://github.com/TeamVanced/VancedMicroG/releases) for non-root YouTube or YT Music  

[revanced-magisk-module](https://github.com/j-hc/revanced-magisk-module)  

---
Changelog:  
CLI: inotia00/revanced-cli-3.1.2-all.jar  
Integrations: inotia00/revanced-integrations-0.117.1.apk  
Patches: inotia00/revanced-patches-2.190.1.jar  

YouTube
==
- feat(youtube): add support version `v18.19.36` & `v18.31.40`
- feat(youtube/litho-filter): update filter
- feat(youtube/shared-resource-id) If the target resource ID is not found, empty index is returned instead of generating patch exception
- fix(youtube/custom-playback-speed): does not work on tablet devices
- fix(youtube/custom-playback-speed): when user opens the sharing panel, the custom playback speed panel opens
- fix(youtube/default-video-quality): rollback commit
- fix(youtube/hide-layout-components): custom filters are separated by commas instead of line-by-line
- fix(youtube/hide-layout-components): expandable chip under videos not hidden in related videos
- fix(youtube/litho-filter): don't remove the buffer until the thread stops
- fix(youtube/old-quality-layout): does not work on tablet devices
- fix(youtube/overlay-button): overlay button not hidden when scrubbing seekbar
- fix(youtube/overlay-button): trim empty space from package name
- fix(youtube/settings): remove disable some settings code for tablet devices
- feat(youtube/translations): update translation
`Chinese Traditional`, `Indonesian`, `Russian`, `Ukrainian`, `Vietnamese`


YouTube Music
==
- feat(music): add compatibility version constraints (ryd does not support older versions)
- feat(music): add `enable-old-style-library-shelf` patch
- feat(music): add `enable-playback-speed` patch
- feat(music): add `hide-button-container-labels` patch
- feat(music): add `hide-emoji-picker` patch
- feat(music): add `hide-flyout-panel` patch
- feat(music): add `hide-radio-button` patch
- feat(music) add `hide-sample-button` patch
- feat(music) add `hide-tooltip-content` patch
- feat(music) add `hook-download-button` patch
- feat(music): add `remember-playback-speed` patch
- feat(music): add `return-youtube-dislike` patch
- feat(music): delete `share-button-hook` patch
- feat(music): remove `decoding-patch` that are no longer used
- feat(music/amoled): patch now applies the amoled theme to the comment input box as well
- feat(music/enable-custom-filter): separate filters by line instead of commas
- feat(music/settings): apply material style to alert dialog
- feat(music/settings): change some default value
- feat(music/settings): remove divider from settings
- feat(music/settings): trim empty space from edit text dialog
- feat(music/settings): when installing for the first time, a reboot dialog is shown
- feat(music/shared-resource-id): If the target resource ID is not found, empty index is returned instead of generating patch exception
- feat(music/hide-get-premium): patch now also hides the premium membership label in settings
- fix(music/exclusive audio playback): not compatible with latest version
- fix(music/hide-upgrade-button): not compatible with latest version
- fix(music/remember-video-quality): not compatible with latest version
- fix(music/settings): blank screen appears when text input dialog is shown
- refactor(music/settings): change settings structure
- feat(music/translations): update translation
`Bengali`, `Brazilian`, `Chinese Simplified`, `Chinese Traditional`, `French`, `Korean`, `Polish`, `Russian`, `Spanish`, `Turkish`, `Vietnamese`


Reddit
==
- feat(reddit): remove `decoding-patch` that are no longer used
- feat(reddit/shared-resource-id) If the target resource ID is not found, empty index is returned instead of generating patch exception


Etc
==
- build: bump patcher to 14.2.2
- build: update gradle and dependency
- chore: `ReadmeGenerator` now generates the minimum and maximum supported versions
- ci: matched with official source

- YT Music now also has version restrictions. check [README.md](https://github.com/inotia00/revanced-patches#-comgoogleandroidappsyoutubemusic)
- in case of RVX Music, clean installation is recommended
- in case of YouTube, the patch is not broken even in the latest beta: `YouTube v18.35.35 beta`
- as some patches may not be applied properly in the latest version due to a/b tests, so I marked the supported version as `YouTube v18.31.40`



※ Compatible ReVanced Manager: [RVX Manager v1.9.5 (fork)](https://github.com/inotia00/revanced-manager/releases/tag/v1.9.5)
[Crowdin translation]
- [YouTube/European Countries](https://crowdin.com/project/revancedextendedeu)
- [YouTube/Other Countries](https://crowdin.com/project/revancedextended)
- [YT Music](https://crowdin.com/project/revanced-music-extended)

---  
