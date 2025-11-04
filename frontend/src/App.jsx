import { BrowserRouter, Routes, Route, Link } from "react-router-dom";
import AccountsList from "./pages/AccountList";
import AccountDetail from "./pages/AccountDetail";
import NewAccount from "./pages/NewAccount";

export default function App() {
    return (
        <BrowserRouter>
            <nav>
                <Link to="/">Accounts</Link>
                <Link to="/new">New</Link>
            </nav>
            <main>
                <Routes>
                    <Route path="/" element={<AccountsList />} />
                    <Route path="/accounts/:name" element={<AccountDetail />} />
                    <Route path="/new" element={<NewAccount />} />
                </Routes>
            </main>
        </BrowserRouter>
    );
}
