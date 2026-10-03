const C='oo-v1';
self.addEventListener('install',e=>{e.waitUntil(caches.open(C).then(c=>Promise.all(['admin.html','customer.html','https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/dist/umd/supabase.min.js'].map(a=>c.add(a).catch(()=>{})))));self.skipWaiting()});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==C).map(x=>caches.delete(x)))));self.clients.claim()});
self.addEventListener('fetch',e=>{const r=e.request,u=new URL(r.url);if(r.method!=='GET'||u.hostname.endsWith('supabase.co'))return;
 const keep=x=>{const cp=x.clone();caches.open(C).then(c=>c.put(r,cp));return x};
 if(u.origin===location.origin)e.respondWith(fetch(r).then(keep).catch(()=>caches.match(r,{ignoreSearch:true})));
 else if(u.hostname.includes('jsdelivr'))e.respondWith(caches.match(r).then(m=>m||fetch(r).then(keep)))});
