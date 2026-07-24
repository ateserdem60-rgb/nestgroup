import { supabase, formatPrice } from "./supabase.js";

const grid = document.getElementById("property-grid");
const state = document.getElementById("property-state");

async function loadProperties() {
  const { data, error } = await supabase
    .from("properties")
    .select("*")
    .eq("published", true)
    .order("featured", { ascending: false })
    .order("created_at", { ascending: false });

  if (error) {
    console.error(error);
    state.innerHTML = '<div class="empty">İlanlar yüklenemedi. Supabase tablo kurulumu ve RLS ayarlarını kontrol edin.</div>';
    return;
  }

  if (!data || data.length === 0) {
    state.innerHTML = '<div class="empty">Henüz yayında ilan bulunmuyor.</div>';
    return;
  }

  state.remove();

  grid.innerHTML = data.map((p) => {
    const photo = p.cover_url || "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=82";
    const meta = [p.district, p.city, p.rooms, p.gross_m2 ? `${p.gross_m2} m²` : ""].filter(Boolean).join(" • ");
    return `
      <article class="property-card">
        <div class="property-photo" style="background-image:url('${photo.replace(/'/g, "%27")}')">
          <span class="property-tag">${p.type || "Portföy"}</span>
        </div>
        <div class="property-body">
          <h3>${escapeHtml(p.title || "Nest Group Portföyü")}</h3>
          <div class="property-meta">${escapeHtml(meta)}</div>
          <div class="property-price">${formatPrice(p.price, p.type)}</div>
          <div class="actions">
            <a class="btn" href="./ilan.html?id=${encodeURIComponent(p.id)}">İlanı İncele</a>
          </div>
        </div>
      </article>`;
  }).join("");
}

function escapeHtml(value = "") {
  return String(value).replace(/[&<>"']/g, (char) => ({
    "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#039;"
  }[char]));
}

loadProperties();
