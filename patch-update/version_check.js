const fetch = require("node-fetch");

const PATCH_API =
  "https://api.github.com/repos/inotia00/revanced-patches/releases/latest";
const VERSION_API =
  "https://raw.githubusercontent.com/mak626/revanced/update/youtube-update.json";
const YOUTUBE_PACKAGE_NAME = "com.google.android.youtube";

const checkVersion = async () => {
  const repoApi = await fetch(PATCH_API);
  const versionApi = await fetch(VERSION_API);

  const json = await repoApi.json();
  const patch_url = json.assets.find(
    (e) => e.name === "patches.json"
  )?.browser_download_url;

  const patches = await (await fetch(patch_url)).json();

  const oldVersion = (await versionApi.json()).version;
  console.log("Old Youtube Version:", oldVersion);

  const versionSet = new Set();
  patches.forEach((e) => {
    const version = e?.compatiblePackages?.find(
      (_e) => _e.name === YOUTUBE_PACKAGE_NAME
    )?.versions;
    if (version) version.forEach((e) => versionSet.add(e));
  });

  const latestVersion = [...versionSet].sort().pop();
  console.log("Latest Youtube Version:", latestVersion);

  if (oldVersion === latestVersion) throw Error("Same Version");
};

checkVersion()
  .then()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
