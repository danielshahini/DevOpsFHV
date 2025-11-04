import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getAccounts, deleteAccount } from "../api/accounts";

export default function AccountsList() {
    const [accounts, setAccounts] = useState([]);
    const [loading, setLoading]   = useState(true);
    const [error, setError]       = useState("");

    async function load() {
        try {
            setLoading(true);
            const data = await getAccounts(); // 204 -> [] in getAccounts behandelt
            setAccounts(data || []);
        } catch (e) {
            setError("Konnte Accounts nicht laden");
        } finally {
            setLoading(false);
        }
    }

    useEffect(() => { load(); }, []);

    async function onDelete(name) {
        if (!confirm(`Konto "${name}" löschen?`)) return;
        await deleteAccount(name);
        await load();
    }

    if (loading) return <p>Lade…</p>;
    if (error)   return <p style={{color:"red"}}>{error}</p>;

    return (
        <div className="container">
            <h2>Accounts</h2>
            <Link to="/new">Neues Konto</Link>
            <ul>
                {accounts.map(a => (
                    <li key={a.name}>
                        <Link to={`/accounts/${encodeURIComponent(a.name)}`}>{a.name}</Link>
                        {" — "}
                        <strong>{a.balance}</strong>
                        {" "}
                        <button className="danger" onClick={() => onDelete(a.name)}>Löschen</button>
                    </li>
                ))}
            </ul>
        </div>
    );
}
