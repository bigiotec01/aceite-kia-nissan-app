// Nombre de la caché para forzar la actualización a la versión 3.0.0
const CACHE_NAME = 'oil-guide-v3.1.2-full-edit';

// Archivos críticos que deben funcionar sin internet (Offline)
const assets = [
  './',
  './index.html',
  './manifest.json',
  './sw.js',
  './icon-192.png',
  './icon-512.png'
];

// 1. Instalación: Descarga los archivos nuevos a la memoria del teléfono
self.addEventListener('install', event => {
  self.skipWaiting(); // Fuerza a la nueva versión a tomar el control de inmediato
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      console.log('Caché Ultra v3.0.0 instalada');
      return cache.addAll(assets);
    })
  );
});

// 2. Activación: Borra la basura y las versiones viejas (v2.9, v2.8, etc.)
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

// 3. Estrategia de Red: Intenta cargar de internet, si no hay, usa la caché (Offline)
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      return response || fetch(event.request);
    })
  );
});
