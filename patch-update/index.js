const savePatches = require("./config.json");
const fs = require("fs");
const fetch = require("node-fetch");

const AUTHOR = "ReVanced";

const PATCH_API = `https://api.github.com/repos/${AUTHOR}/revanced-patches/releases/latest`;
const YOUTUBE_PACKAGE_NAME = "com.google.android.youtube";
const CONFIG_PATH = "./config.toml";

const checkPatch = async () => {
  const repoDownload = await fetch(PATCH_API);

  const json = await repoDownload.json();
  console.log("VERSION:", json.name);
  const errors = [`Patch Version: _${json.name}_`];

  const patch_url = json.assets.find(
    (e) => e.name === "patches.json"
  )?.browser_download_url;

  const convertToQuote = ({ name, ...data }) => ({
    ...data,
    name: `'${name}'`,
  });

  const patches = (await (await fetch(patch_url)).json()).map(convertToQuote);

  const oldExclude = savePatches.exclude.sort();
  const oldInclude = savePatches.include.sort();

  let excludedPatches = [];
  let includedPatches = [];
  patches.forEach(({ use, name, compatiblePackages }) => {
    if (compatiblePackages?.find((e) => e.name == YOUTUBE_PACKAGE_NAME)) {
      if (use == false) excludedPatches.push(name);
      else includedPatches.push(name);
    }
  });

  excludedPatches = excludedPatches.sort();
  includedPatches = includedPatches.sort();

  oldExclude.forEach((e) => {
    if (!includedPatches.find((_e) => _e === e)) {
      console.log(`[INCLUDE] ${e} not found`);
      errors.push(`[INCLUDE]: ${e}`);
    }
  });

  oldInclude.forEach((e) => {
    if (!excludedPatches.find((_e) => _e === e)) {
      console.log(`[EXCLUDE] ${e} not found`);
      errors.push(`[EXCLUDE]: ${e}`);
    }
  });

  if (errors.length > 1) {
    fs.writeFileSync("./errors.log", errors.join("\n"));
    throw "Config need updating";
  }

  const patches_applied = {
    excluded: Array.from(
      new Set([
        ...oldExclude,
        ...excludedPatches.filter((e) => !oldInclude.includes(e)),
      ])
    ).sort(),
    included: Array.from(
      new Set([
        ...oldInclude,
        ...includedPatches.filter((e) => !oldExclude.includes(e)),
      ])
    ).sort(),
  };

  const config = fs.readFileSync(CONFIG_PATH, { encoding: "utf-8" });
  const data = config.split("\n");
  data.splice(-2, 2);
  data.push(
    `excluded-patches = "${oldExclude.join(" ")}"`,
    `included-patches = "${oldInclude.join(" ")}"`
  );

  // Update config.toml
  fs.writeFileSync(CONFIG_PATH, data.join("\n"));

  fs.writeFileSync(
    "./patch-update/patches.json",
    JSON.stringify(
      { excluded: excludedPatches, included: includedPatches },
      null,
      4
    )
  );

  fs.writeFileSync(
    "./patch-update/patches_applied.json",
    JSON.stringify(patches_applied, null, 4)
  );
};

checkPatch()
  .then()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });

