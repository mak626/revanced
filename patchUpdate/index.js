const repo =
  "https://api.github.com/repos/inotia00/revanced-patches/releases/latest";

const savePatches = require("./config.json");
const fs = require("fs");
const fetch = require("node-fetch");

const checkPatch = async () => {
  const repoDownload = await fetch(repo);

  const json = await repoDownload.json();
  console.log("VERSION: ", json.name);
  const patch_url = json.assets.find(
    (e) => e.name === "patches.json"
  )?.browser_download_url;

  const patches = await (await fetch(patch_url)).json();

  const oldExclude = savePatches.exclude;
  const oldInclude = savePatches.include;

  const excluded = [];
  const included = [];

  patches.forEach((e) => {
    if (
      e.compatiblePackages.find((e) => e.name == "com.google.android.youtube")
    ) {
      if (e.excluded) {
        excluded.push(e.name);
      } else {
        included.push(e.name);
      }
    }
  });

  oldExclude.forEach((e) => {
    if (!included.find((_e) => e === _e)) {
      console.log(`[INCLUDE] ${e} not found`);
    }
  });

  oldInclude.forEach((e) => {
    if (!excluded.find((_e) => e === _e)) {
      console.log(`[EXCLUDE] ${e} not found`);
    }
  });

  fs.writeFileSync(
    "./patchUpdate/config.toml",
    `excluded-patches = "${excluded.join(
      " "
    )}"\nincluded-patches = "${included.join(" ")}"`
  );

  fs.writeFileSync(
    "./patchUpdate/patches.json",
    JSON.stringify({ excluded, included }, null, 4)
  );
  fs.writeFileSync(
    "./patchUpdate/patches_applied.json",
    JSON.stringify(
      {
        excluded: Array.from(
          new Set([
            ...oldExclude,
            ...excluded.filter((e) => !oldInclude.includes(e)),
          ])
        ),
        included: Array.from(
          new Set([
            ...oldInclude,
            ...included.filter((e) => !oldExclude.includes(e)),
          ])
        ),
      },
      null,
      4
    )
  );
};

checkPatch();
