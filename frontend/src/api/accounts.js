import { api } from './client';

export async function getAccounts() {
    const res = await api.get('/accounts'); // GET /api/v1/accounts
    return res.data ?? [];
}

export async function getAccount(name) {
    const res = await api.get(`/accounts/${encodeURIComponent(name)}`);
    return res.data;
}

export async function createAccount(name) {
    // POST /api/v1/accounts/createAccount?name=...
    const res = await api.post('/accounts/createAccount', null, { params: { name }});
    return res.data;
}

export async function deleteAccount(name) {
    await api.delete(`/accounts/${encodeURIComponent(name)}`);
}

export async function deposit(name, value) {
    const res = await api.post(`/accounts/${encodeURIComponent(name)}/deposit`, null, { params: { value }});
    return res.data;
}

export async function withdraw(name, value) {
    const res = await api.post(`/accounts/${encodeURIComponent(name)}/withdraw`, null, { params: { value }});
    return res.data;
}

export async function transfer(fromName, toName, value) {
    const res = await api.post(`/accounts/${encodeURIComponent(fromName)}/transfer`, null, {
        params: { sendTo: toName, value }
    });
    return res.data; // Liste mit beiden Accounts
}
