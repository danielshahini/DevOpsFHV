import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { createAccount } from "../api/accounts";

export default function NewAccount() {
    const [name, setName] = useState("");
    const [err, setErr] = useState("");
    const nav = useNavigate();

    async function onSubmit(e){
        e.preventDefault();
        setErr("");
        try {
            await createAccount(name);
            nav(`/accounts/${encodeURIComponent(name)}`);
        } catch (e) {
            setErr("Konto konnte nicht erstellt werden (evtl. bereits vorhanden).");
        }
    }

    return (
        <form onSubmit={onSubmit} style={{display:"grid", gap:8, maxWidth:360}}>
            <Link to="/">← Zurück</Link>
            <h2>Neues Konto</h2>
            <input placeholder="Kontoname" value={name} onChange={e=>setName(e.target.value)} required />
            <button type="submit">Erstellen</button>
            {err && <p style={{color:"red"}}>{err}</p>}
        </form>
    );
}
