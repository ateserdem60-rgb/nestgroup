
import { supabase, money } from './supabase.js';

const grid = document.querySelector('#property-grid');
const status = document.querySelector('#property-status');

async function loadProperties(){
  const { data, error } = await supabase
    .from('properties')
    .select('id,listing_no,title,type,status,price,city,district,rooms,gross_m2,cover_url,featured,created_at')
    .eq('published', true)
    .order('featured', { ascending: false })
    .order('created_at', { ascending: false })
    .limit(12);

  if(error){
    status.innerHTML = `<div class="empty">İlanlar yüklenemedi. Supabase kurulum SQL'inin çalıştırıldığından emin olun.</div>`;
    console.error(error);
    return;
  }

  if(!data?.length){
    status.innerHTML = `<div class="empty">Henüz yayında ilan bulunmuyor.</div>`;
    return;
  }

  status.remove();
  grid.innerHTML = data.map(p => `
    <article class="card dark">
      <img src="${p.cover_url || 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80'}" alt="">
      <div class="card-body">
        <span class="tag">${(p.type || 'PORTFÖY').toUpperCase()}</span>
        <h3>${p.title}</h3>
        <div class="meta">${[p.district,p.city,p.rooms,p.gross_m2 ? p.gross_m2+' m²' : ''].filter(Boolean).join(' • ')}</div>
        <div class="price">${money(p.price, p.type === 'Kiralık')}</div>
        <div class="actions"><a class="btn" href="/ilan.html?id=${encodeURIComponent(p.id)}">İlanı İncele</a></div>
      </div>
    </article>`).join('');
}
loadProperties();
