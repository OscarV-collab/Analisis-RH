const { createClient } = require('@supabase/supabase-js');

const adminClient = () => createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);
async function isAdmin(req) {
  const token = (req.headers.authorization || '').replace('Bearer ', '');
  const publicClient = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_ANON_KEY);
  const { data: authData } = await publicClient.auth.getUser(token);
  if (!authData?.user) return null;
  const service = adminClient();
  const { data: profile } = await service.from('profiles').select('role').eq('id', authData.user.id).single();
  return profile?.role === 'ADMIN' ? authData.user : null;
}
module.exports = async (req, res) => {
  const current = await isAdmin(req);
  if (!current) return res.status(403).json({ error: 'Solo un administrador puede realizar esta acción.' });
  const service = adminClient();
  if (req.method === 'GET') {
    const [{ data: usersData, error }, { data: profiles }] = await Promise.all([
      service.auth.admin.listUsers({ page: 1, perPage: 1000 }), service.from('profiles').select('id,name,email,role,active')
    ]);
    if (error) return res.status(400).json({ error: error.message });
    const profileMap = new Map((profiles || []).map(p => [p.id, p]));
    return res.status(200).json({ users: usersData.users.map(u => ({ id: u.id, email: u.email, created_at: u.created_at, ...(profileMap.get(u.id) || { role: 'RH', active: true }) })) });
  }
  if (req.method === 'POST') {
    const { name, email, password, role } = req.body || {};
    if (!name || !email || !password || password.length < 8) return res.status(400).json({ error: 'Nombre, correo y contraseña de al menos 8 caracteres son obligatorios.' });
    const { data, error } = await service.auth.admin.createUser({ email, password, email_confirm: true, user_metadata: { name } });
    if (error) return res.status(400).json({ error: error.message });
    await service.from('profiles').upsert({ id: data.user.id, name, email, role: role === 'ADMIN' ? 'ADMIN' : 'RH', active: true });
    return res.status(201).json({ user: { id: data.user.id, name, email, role } });
  }
  if (req.method === 'PATCH') {
    const { userId, password } = req.body || {};
    if (!userId || !password || password.length < 8) return res.status(400).json({ error: 'La nueva contraseña debe tener al menos 8 caracteres.' });
    const { error } = await service.auth.admin.updateUserById(userId, { password });
    return error ? res.status(400).json({ error: error.message }) : res.status(200).json({ ok: true });
  }
  return res.status(405).end();
};
