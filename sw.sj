const CACHE_NAME = 'oil-guide-v2.2';
const assets = [
  '/',
  '/index.html',
  '/manifest.json'
];

// Instalación y limpieza de caches antiguas
self.addEventListener('install', event => {
  self.skipWaiting(); // Fuerza al SW nuevo a tomar el control
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(assets))
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.filter(key => key !== CACHE_NAME)
            .map(key => caches.delete(key)) // Borra versiones viejas
      );
    })
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      return response || fetch(event.request);
    })
  );
});
