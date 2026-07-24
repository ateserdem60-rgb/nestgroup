
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';
import { SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY } from './config.js';

export const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, {
  auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
});

export function money(value, rent=false){
  if(value === null || value === undefined || value === '') return 'Fiyat için iletişime geçin';
  const n = Number(value);
  const formatted = new Intl.NumberFormat('tr-TR').format(n) + ' ₺';
  return rent ? formatted + ' / Ay' : formatted;
}

export function safeText(value){ return value ?? ''; }

export async function requireAdmin(){
  const { data: { session } } = await supabase.auth.getSession();
  if(!session){
    location.href = '/admin/login.html';
    return null;
  }
  return session;
}
