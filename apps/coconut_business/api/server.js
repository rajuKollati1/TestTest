const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// Postgres connection using env vars (from your Kubernetes secret)
const pool = new Pool({
  host: process.env.DB_HOST || 'postgres',
  port: process.env.DB_PORT ? parseInt(process.env.DB_PORT) : 5432,
  user: process.env.DB_USER || 'coconut_user',
  password: process.env.DB_PASSWORD || 'postgres_pass',
  database: process.env.DB_NAME || 'coconut_db',
});

// Initialize tables if not exists (very small and sync on startup)
async function initDb(){
  await pool.query(`
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      email TEXT UNIQUE NOT NULL,
      password_hash TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT now()
    );
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS orders (
      id SERIAL PRIMARY KEY,
      user_email TEXT,
      product TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      created_at TIMESTAMP DEFAULT now()
    );
  `);
}

app.get('/', (req, res) => res.json({ok:true, msg:'coconut-api running'}));

// Signup - stores email and password hash
app.post('/signup', async (req, res) => {
  const { email, password } = req.body || {};
  if (!email || !password) return res.status(400).json({ error: 'email and password required' });
  try{
    const hash = await bcrypt.hash(password, 8);
    await pool.query('INSERT INTO users(email, password_hash) VALUES($1,$2) ON CONFLICT (email) DO NOTHING', [email, hash]);
    res.json({ ok: true, email });
  }catch(err){
    console.error(err);
    res.status(500).json({ error: 'db error' });
  }
});

// Signin - checks password
app.post('/signin', async (req, res) => {
  const { email, password } = req.body || {};
  if (!email || !password) return res.status(400).json({ error: 'email and password required' });
  try{
    const result = await pool.query('SELECT password_hash FROM users WHERE email = $1', [email]);
    if (result.rowCount === 0) return res.status(401).json({ error: 'invalid credentials' });
    const row = result.rows[0];
    const ok = await bcrypt.compare(password, row.password_hash);
    if (!ok) return res.status(401).json({ error: 'invalid credentials' });
    // Return a very small session token (insecure demo). For real apps use JWT or session store.
    res.json({ ok: true, email });
  }catch(err){
    console.error(err);
    res.status(500).json({ error: 'db error' });
  }
});

// Create order
app.post('/order', async (req, res) => {
  const { email, product, quantity } = req.body || {};
  if (!product || !quantity) return res.status(400).json({ error: 'product and quantity required' });
  try{
    await pool.query('INSERT INTO orders(user_email, product, quantity) VALUES($1,$2,$3)', [email || null, product, parseInt(quantity,10)]);
    res.json({ ok: true });
  }catch(err){
    console.error(err);
    res.status(500).json({ error: 'db error' });
  }
});

// Simple endpoint to get order count for product
app.get('/orders/count/:product', async (req, res) => {
  const product = req.params.product;
  try{
    const r = await pool.query('SELECT SUM(quantity) as total FROM orders WHERE product = $1', [product]);
    const total = r.rows[0].total || 0;
    res.json({ product, total: parseInt(total,10) });
  }catch(err){
    console.error(err);
    res.status(500).json({ error: 'db error' });
  }
});

const PORT = process.env.PORT || 3000;

initDb().then(()=>{
  app.listen(PORT, ()=> console.log('coconut-api listening on', PORT));
}).catch(err=>{
  console.error('Failed to init DB', err);
  process.exit(1);
});
