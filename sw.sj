const CACHE_NAME = 'oil-guide-v2.5.1-optima';
const assets = [
  './',
  './index.html',
  './manifest.json',
  './sw.js'
];

// Instala el Service Worker y guarda los archivos en caché
self.addEventListener('install', event => {
  self.skipWaiting(); // Fuerza la activación inmediata
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll(assets);
    })
  );
});

// Elimina cachés antiguas para liberar espacio y evitar errores 404
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.filter(key => key !== CACHE_NAME)
            .map(key => caches.delete(key))
      );
    })
  );
});

// Sirve los archivos desde la caché para que la app funcione sin internet
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      return response || fetch(event.request);
    })
  );
});
