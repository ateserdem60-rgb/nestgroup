import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm";
import { SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY } from "./config.js";

export const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true
  }
});

export function formatPrice(value, type = "") {
  if (value === null || value === undefined || value === "") return "Fiyat için iletişime geçin";
  const formatted = new Intl.NumberFormat("tr-TR").format(Number(value)) + " ₺";
  return type === "Kiralık" ? formatted + " / Ay" : formatted;
}

export async function requireAdmin() {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) {
    window.location.href = "./admin-login.html";
    return null;
  }
  return session;
}
