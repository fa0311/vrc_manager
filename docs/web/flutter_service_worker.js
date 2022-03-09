'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "ccf1528aadaf0379840b49cb3392f9ec",
"assets/assets/svg/bandsintown.svg": "3fed4399185d3999f17d9f4744e59d36",
"assets/assets/svg/behance.svg": "49bcc686b97daaeee154ac0fedb81b4b",
"assets/assets/svg/codepen.svg": "6c20f1ad191ee9838273d2df799af6a6",
"assets/assets/svg/dribbble.svg": "ac72a434b3589f2a29893f9d7072b3e1",
"assets/assets/svg/dropbox.svg": "beff88a5867d52192b667886d4f2ed82",
"assets/assets/svg/email.svg": "9e9a93e69476535bef8517a23a5baca9",
"assets/assets/svg/facebook.svg": "a0f086cd54b490a90601a7b395a87dc9",
"assets/assets/svg/fivehundredpix.svg": "5d72978c989c2b0a1324a3026f61723f",
"assets/assets/svg/flickr.svg": "1fbe221e84e798c9974b6e348bdb0506",
"assets/assets/svg/foursquare.svg": "908a4f0c65961219672e1954aed834a0",
"assets/assets/svg/github.svg": "99ea145ff6f57b658daf5eba6736962f",
"assets/assets/svg/google.svg": "289128edea13efc0ac2487385056ca3e",
"assets/assets/svg/google_play.svg": "9c5336ae679f26f50c1f315ac779269d",
"assets/assets/svg/instagram.svg": "869579c94ae6b05a622a04c66d8f0cd3",
"assets/assets/svg/itunes.svg": "faa3ccca7efcfbbafc2d5784da358dc0",
"assets/assets/svg/linkedin.svg": "ed6c822e89b61a3b443cc3a8b0ee35bd",
"assets/assets/svg/mailto.svg": "9e9a93e69476535bef8517a23a5baca9",
"assets/assets/svg/medium.svg": "c04fa11b44e9ce33a301d38434b7c2e7",
"assets/assets/svg/meetup.svg": "8eca3f6434ac0ff049a0823ab3d5bd7d",
"assets/assets/svg/pinterest.svg": "c5ae0fd1b90874aef52d78a54928a20c",
"assets/assets/svg/rdio.svg": "97c150df0df8e5077393cd84f6ed9dbc",
"assets/assets/svg/reddit.svg": "e629bc8c12b4686288da98bce1b3a98a",
"assets/assets/svg/rss.svg": "8d549e20819eceecab3a0c109bc226b4",
"assets/assets/svg/sharethis.svg": "6a97b39687c79aed0a44d018f7b69be9",
"assets/assets/svg/smugmug.svg": "3dc4a7edc0bcf448a2d1ea5fc38911c0",
"assets/assets/svg/snapchat.svg": "6770c3935f728de2ef47be75e42df344",
"assets/assets/svg/soundcloud.svg": "fba6720fe73a94c4cb606c6832fa8389",
"assets/assets/svg/spotify.svg": "d9cdfc811b27f485eb8a8e50d3e7c776",
"assets/assets/svg/squarespace.svg": "cf1a06be1708c6fc5e13893e15d08886",
"assets/assets/svg/svg.json": "9e3181ee1ac2c6c00f72ff9549ebc1a8",
"assets/assets/svg/svg.py": "b1540f43fc438ac822b3a17451c88027",
"assets/assets/svg/tumblr.svg": "6b32d25bdd61ac06428e6db89bfe76fe",
"assets/assets/svg/twitch.svg": "b05214c5b2b9bdf819671ea694100670",
"assets/assets/svg/twitter.svg": "01b293a12906e206a809b7c2088701dc",
"assets/assets/svg/vevo.svg": "96d1f0a2f0ce543d9aa07fbe4efca899",
"assets/assets/svg/vimeo.svg": "e8470f0b3d800aa00340f344080c38dd",
"assets/assets/svg/vine.svg": "fe9e6a75ab065cf1ebd6ad7ef1c064ca",
"assets/assets/svg/vk.svg": "afcc780b3991a3c3cf53145ba1fe50dc",
"assets/assets/svg/vsco.svg": "33a3f323696a1675a46c429e38c09c61",
"assets/assets/svg/wechat.svg": "3eada8a4fcafa041fe08131e0a29ca8e",
"assets/assets/svg/whatsapp.svg": "0f23f9446fce07d07ddf29486cef9074",
"assets/assets/svg/yelp.svg": "1df19fbb0e68669fc5fa750de2288131",
"assets/assets/svg/youtube.svg": "16a3fc9d4e69da570ff65bc553305933",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"assets/NOTICES": "7160aacf169049b6c68ae04e0c2ac9be",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "cc7a88d8b9c2f882092b38ce3670cbd8",
"/": "cc7a88d8b9c2f882092b38ce3670cbd8",
"main.dart.js": "7fb58435c963da357896d057c5b5c147",
"manifest.json": "d205ce0193a5cec1106ea21867464a05",
"version.json": "fb621d069e5276b4a9b1c9b11a94e73f"
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
