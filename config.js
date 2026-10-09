// Подключение к Supabase. Заполните два значения из Supabase → Project Settings → API.
// Это публичные данные: защита держится на правилах доступа (RLS) из supabase.sql.
// Пока поля пустые, ежедневник работает как раньше — только на этом устройстве.
window.FORMAT_CONFIG = {
  SUPABASE_URL: "https://ioxmpjtdxslqewmshanr.supabase.co/rest/v1",       // например: https://abcdxyz.supabase.co
  SUPABASE_ANON_KEY: "sb_publishable_YGZrizcqxEnCLOAvUoxhvw_sfFsw0Hy"   // длинный ключ «anon public» (или «publishable»)
};
