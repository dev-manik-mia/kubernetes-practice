import { useEffect, useState } from "react";

export default function App() {
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch("/api")
      .then((res) => {
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        return res.json();
      })
      .then((json) => setData(json))
      .catch((err) => setError(err.message));
  }, []);

  return (
    <div
      style={{
        fontFamily: "Arial",
        padding: "40px",
      }}
    >
      <h1>Frontend Running</h1>

      {error && <p style={{ color: "red" }}>Error: {error}</p>}

      {data && (
        <div>
          <p>{data.message}</p>
          <p>Total Visits: {data.totalVisits}</p>
          <p>Cached Visits: {data.cachedVisits}</p>
        </div>
      )}
    </div>
  );
}