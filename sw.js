/**
 * Service Worker: 出張旅費精算アプリ PWA
 * 常に最新を優先（Network First）→ オフライン時のみキャッシュを使用
 */
const CACHE_NAME = 'fkt-srk-app-v1';

// 常にネットワークを優先し、失敗時のみキャッシュを使う（常に最新で開く）
async function networkFirst(request) {
  try {
    const response = await fetch(request);
    if (response && response.status === 200 && response.type === 'basic') {
      const clone = response.clone();
      const cache = await caches.open(CACHE_NAME);
      cache.put(request, clone);
    }
    return response;
  } catch (e) {
    const cached = await caches.match(request);
    return cached || new Response('オフラインです。', { status: 503, statusText: 'Service Unavailable' });
  }
}

self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  // 同一オリジンの HTML / JS / JSON とマニフェスト・アイコンは常にネットワーク優先
  if (event.request.mode === 'navigate' || event.request.destination === 'document') {
    event.respondWith(networkFirst(event.request));
    return;
  }
  if (url.pathname.endsWith('.html') || url.pathname.endsWith('.js') || url.pathname.endsWith('manifest.json') || url.pathname.endsWith('icon.svg') || url.pathname.endsWith('sw.js')) {
    event.respondWith(networkFirst(event.request));
    return;
  }
  // CDN 等はそのまま fetch（キャッシュしない＝常に最新）
  event.respondWith(fetch(event.request).catch(() => caches.match(event.request)));
});
