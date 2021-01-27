'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "icons/ms-icon-310x310.png": "1def877bad3f3f7ebbe06778823dbab6",
"icons/ms-icon-144x144.png": "0c1da8f3307bebc3d462e3648a56c0d8",
"icons/apple-icon-57x57.png": "02b0fe890eb66ecd599dd677dcc2896e",
"icons/ms-icon-70x70.png": "f56d593197d0564b5ae90d79735ab6ab",
"icons/apple-icon-60x60.png": "53ea414a4260660c741da3e9c66d24d5",
"icons/ms-icon-150x150.png": "b9fdb17bc944bd46e9a6182808d301f4",
"icons/logo.png": "402709f1cff507ddfcc29d89ac0a1417",
"icons/favicon.ico": "3af5d1813b45486f3cc0e2f25a483811",
"icons/favicon-32x32.png": "e1a45747241ef1bc0ecdf212bb7d1b09",
"icons/android-icon-36x36.png": "806e4396983a73c3bc887f0dfbba0896",
"icons/manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"icons/apple-icon-76x76.png": "4a94df5418f9bb6b37d55f69145d0e67",
"icons/apple-icon-114x114.png": "e0d97447dd5c10867a97010c232d9e8c",
"icons/favicon-16x16.png": "6a344b99f9827bbf8da5dadd4baa8e04",
"icons/apple-icon-152x152.png": "868dc2322d195fcac575a5212f1e85fb",
"icons/android-icon-72x72.png": "28557924d353b8380f7f5812266a2754",
"icons/favicon-96x96.png": "56afaae8dca87c513fc689dd3367f425",
"icons/android-icon-96x96.png": "56afaae8dca87c513fc689dd3367f425",
"icons/apple-icon-120x120.png": "46c1301479c99f69558ea58c45e27af9",
"icons/apple-icon.png": "7b427aa95a32011c967229fd14ed1854",
"icons/apple-icon-72x72.png": "28557924d353b8380f7f5812266a2754",
"icons/apple-icon-precomposed.png": "7b427aa95a32011c967229fd14ed1854",
"icons/maskable_icon.png": "a35e81aa1dd7c500428475d246f71cdd",
"icons/apple-icon-180x180.png": "a29673f526e35556dfe59a9419300e8d",
"icons/android-icon-48x48.png": "6e14fc1b936565f942fc8f7a387e92cc",
"icons/android-icon-144x144.png": "0c1da8f3307bebc3d462e3648a56c0d8",
"icons/apple-icon-144x144.png": "0c1da8f3307bebc3d462e3648a56c0d8",
"icons/android-icon-192x192.png": "11a1b069c5b3ce5c384685bfdd34a950",
"icons/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"manifest.json": "12bbf51851ecc3bdfe677f9847c52cde",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/NOTICES": "35a769459960b27a58e012d6b8a21118",
"assets/AssetManifest.json": "2efbb41d7877d10aac9d091f58ccd7b9",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"index.html": "83aa8d10fe2c55c0cb0a918bd7508e79",
"/": "83aa8d10fe2c55c0cb0a918bd7508e79",
"version.json": "a5a265f40f65cea5f2f382296a750595",
"main.dart.js": "3b1352fdf966e70ce32328f37157a9a0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796"
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
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
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
  for (var resourceKey in Object.keys(RESOURCES)) {
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
