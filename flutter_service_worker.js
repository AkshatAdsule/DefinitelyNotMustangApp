'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/NOTICES": "196a7ae603480b902c863b7d15792a6b",
"assets/assets/2022_rightred_leftblue.png": "840c0c32acc55af04c845641ca52875c",
"assets/assets/r2d2.png": "871896aacbc4c4a2a50c19ccfc7db555",
"assets/assets/data_collection/2015.csv": "011ac054fa71412255ca62b68db2f5fd",
"assets/assets/data_collection/2013.csv": "0cdc35e39173281e283d91fd3b1a41d5",
"assets/assets/data_collection/2014.csv": "96196e798f0162740c000ea14ff894c2",
"assets/assets/data_collection/2017.csv": "a448f632634fe526abc22b6c7354ca48",
"assets/assets/data_collection/2020.csv": "fe00ea374db5dadb20fe504915cb30f3",
"assets/assets/data_collection/2019.csv": "da7afbc81c584892ab23c343d5a5e3d4",
"assets/assets/data_collection/2018.csv": "eae686395f153938b8d5ee5bf786c372",
"assets/assets/data_collection/2016.csv": "8597eed97cb0da6e9123fc5e01f2f9a1",
"assets/assets/rightred_leftblue.png": "2363927b1c5f112a522a740f3e2717fe",
"assets/assets/bb8.png": "090c5c49774bc8a9f42aa0e2c9f297a3",
"assets/assets/logo.png": "74a573c00e24d423408aba6e28e742bd",
"assets/assets/facebook.jpg": "e78b8801fec15b36530841424b13057d",
"assets/assets/goal.jpg": "bbfef19de498aaa2b9a2ce1d1804ba13",
"assets/assets/goal_cropped.jpg": "bd9b8ac3c706be7d28cd7539b577dd71",
"assets/assets/2022_rightblue_leftred.png": "bd148823f88cf50ee8a85e45d939bc5e",
"assets/assets/bb8.gif": "4f53a48fd28d62864c96cb8f28ed9004",
"assets/assets/map.png": "135ed2917307a3f58526e91714609523",
"assets/assets/rightblue_leftred.png": "aa947ec156c10e56c8f8ecafecbad707",
"assets/assets/data.csv": "5161e94da0f9a63456263bf7ef15f542",
"assets/assets/logo_padded.png": "d8444c0bd738e5ab2cd20571092d61cc",
"assets/assets/google.jpg": "d0991539b51f1520c42d1dee04ba0faa",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/AssetManifest.json": "2dc5a26f9fdc5a9981aa5adddf7093e3",
"assets/packages/flutter_inappwebview/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "aa1ec80f1b30a51d64c72f669c1326a7",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "5178af1d278432bec8fc830d50996d6f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b37ae0f14cbc958316fac4635383b6e8",
"assets/packages/youtube_player_flutter/assets/speedometer.webp": "50448630e948b5b3998ae5a5d112622b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"manifest.json": "d95ff72d59db1eef1c4849b6084276ee",
"CNAME": "8c1500ff42f8f5b6ba220b8cd0ce4866",
"index.html": "4e92eb5d1bc542ccea90623d7b4b99f5",
"/": "4e92eb5d1bc542ccea90623d7b4b99f5",
"splash/img/dark-1x.png": "6d67e8eeed41de28f3b5fb55cbbb96fe",
"splash/img/light-2x.png": "3cfc17ce35a5b8d476ee8da9fff651c6",
"splash/img/dark-2x.png": "3cfc17ce35a5b8d476ee8da9fff651c6",
"splash/img/dark-3x.png": "69336932e112ab8d27ba55651ad629ec",
"splash/img/dark-4x.png": "37f984713c5c8a7635894710d841f8d0",
"splash/img/light-3x.png": "69336932e112ab8d27ba55651ad629ec",
"splash/img/light-1x.png": "6d67e8eeed41de28f3b5fb55cbbb96fe",
"splash/img/light-4x.png": "37f984713c5c8a7635894710d841f8d0",
"splash/style.css": "6747db84c9ab36c9b53a28c56f84a37f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"main.dart.js": "eb72f73565f2d5ba8e85b14069781df4",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "52713857909a8511cff34736b9c5e236"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
