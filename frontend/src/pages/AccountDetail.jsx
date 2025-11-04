import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { getAccount, deposit, withdraw, transfer } from "../api/accounts";

export default function AccountDetail() {
    const { name } = useParams();
    const [acc, setAcc] = useState(null);
    const [value, setValue] = useState("");
    const [to, setTo] = useState("");

    async function load() {
        const data = await getAccount(name);
        setAcc(data);
    }
    useEffect(() => { load(); }, [name]);

    if (!acc) return <p>Lade…</p>;

    return (
        <div className="container">
            <p><Link to="/">← Zur Liste</Link></p>
            <h2>{acc.name}</h2>
            <p>Kontostand: <strong>{acc.balance}</strong></p>

            {/* Aktionsbereich: Beträge eingeben, Ein-/Aus-/Überweisen */}
            <div className="actions">
                <input
                    type="number"
                    placeholder="Betrag"
                    value={value}
                    onChange={e => setValue(e.target.value)}
                />
                <button
                    type="button"
                    onClick={async () => {
                        await deposit(name, value);
                        setValue("");
                        await load();
                    }}
                >
                    Einzahlen
                </button>
                <button
                    type="button"
                    onClick={async () => {
                        await withdraw(name, value);
                        setValue("");
                        await load();
                    }}
                >
                    Abheben
                </button>
                <input
                    type="text"
                    placeholder="Empfänger (Name)"
                    value={to}
                    onChange={e => setTo(e.target.value)}
                />
                <button
                    type="button"
                    onClick={async () => {
                        await transfer(name, to, value);
                        setTo("");
                        setValue("");
                        await load();
                    }}
                >
                    Überweisen
                </button>
            </div>
        </div>
    );
}
