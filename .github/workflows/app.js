// Adjust API base if your API is hosted elsewhere. In-cluster you can proxy /api to the service.
const API = '/api';
let currentEmail = null;

async function jsonFetch(path, opts){
  const res = await fetch(API + path, opts);
  try{ return await res.json(); }catch(e){ return { error: 'invalid json' } }
}

async function signup(){
  const email = document.getElementById('email').value.trim();
  const password = document.getElementById('password').value;
  const j = await jsonFetch('/signup', { method:'POST', headers:{'content-type':'application/json'}, body: JSON.stringify({email,password}) });
  document.getElementById('authMsg').innerText = j.error ? ('Error: '+j.error) : ('Signed up: '+(j.email||''));
}

async function signin(){
  const email = document.getElementById('email').value.trim();
  const password = document.getElementById('password').value;
  const j = await jsonFetch('/signin', { method:'POST', headers:{'content-type':'application/json'}, body: JSON.stringify({email,password}) });
  if(j.ok){ currentEmail = email; document.getElementById('authMsg').innerText = 'Signed in as '+email } else { document.getElementById('authMsg').innerText = j.error || 'Sign in failed' }
}

async function addCoconuts(){
  const qty = parseInt(document.getElementById('qty').value||'1',10);
  if(qty <= 0) return alert('Enter a positive quantity');
  const j = await jsonFetch('/order', { method:'POST', headers:{'content-type':'application/json'}, body: JSON.stringify({ email: currentEmail, product: 'coconut', quantity: qty }) });
  if(j.ok){ await refreshTotal(); } else { alert('Order failed: '+(j.error||'unknown')) }
}

async function refreshTotal(){
  const j = await jsonFetch('/orders/count/coconut');
  document.getElementById('total').innerText = (j && j.total) ? j.total : 0;
}

document.getElementById('signup').addEventListener('click', signup);
document.getElementById('signin').addEventListener('click', signin);
document.getElementById('add').addEventListener('click', addCoconuts);

// load initial total
refreshTotal();