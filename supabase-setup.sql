# Nest Group + Supabase

## 1) Supabase kurulumu
Supabase projenizde `supabase-setup.sql` içeriğini SQL Editor'da çalıştırın.

## 2) Admin kullanıcı oluşturun
Supabase > Authentication > Users > Add user
- E-posta: kendi admin e-postanız
- Şifre: güçlü bir şifre
- Auto confirm: açık olabilir

## 3) Vercel
Bu klasörü Vercel'e deploy edin. Framework Preset: Other / Static.

## 4) Admin
`/admin/login.html`

## Güvenlik
Frontend sadece Publishable Key kullanır.
Secret / service_role key tarayıcıya konmamalıdır.
