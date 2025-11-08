# Import Grafana Dashboards using Grafana Dashboards Site — Step-by-Step Guide

This guide explains how to **import dashboards** from the [Grafana Dashboards](https://grafana.com/grafana/dashboards/) website using the dashboard ID and how to **save them in JSON format**.

---

## 1. Prerequisites

Before you begin, make sure you have:

* Grafana installed and accessible (e.g., `http://localhost:3000`)
* Admin or Editor access to Grafana
* A working **Prometheus** (or other) data source configured

---

## 2. Open Grafana Dashboard Library

1. Visit: [https://grafana.com/grafana/dashboards/](https://grafana.com/grafana/dashboards/)
2. You’ll see thousands of community dashboards.
3. Use the **search bar** to find dashboards for your data source, for example:

   * `Node Exporter` for Linux metrics
   * `Kubernetes cluster monitoring`
   * `NGINX`, `MySQL`, `Docker`, etc.

---

## 3. Copy the Dashboard ID

1. Click on the dashboard you want.
2. On the top-right side of the dashboard page, you’ll see an **ID number**.

   * Example: `1860` (for Node Exporter Full dashboard)
3. Copy that ID.

---

## 4. Import the Dashboard into Grafana

1. Open your Grafana UI (e.g., `http://localhost:3000`)
2. In the left-hand sidebar, click:

   ```
   Dashboards → Import
   ```
3. Paste the copied ID into the input box that says **“Import via grafana.com”**.
4. Click **Load**.
5. Choose your **data source** (e.g., Prometheus).
6. Click **Import**.

✅ The dashboard will appear immediately under your dashboards list.

---

## 5. View and Customize the Imported Dashboard

* After importing, you can edit any panel, change queries, or rearrange panels.
* You can also rename the dashboard from the top of the page.

---

## 6. Export the Dashboard as JSON

You can save the imported dashboard as a JSON file for backup or reuse.

1. Open the dashboard you want to export.
2. Click the **Share icon (⤴)** → **Export → View JSON**.
3. Click **Save to file**.
4. It will download as a `.json` file, e.g., `node_exporter_dashboard.json`.

Alternatively, you can also use the API:

```bash
curl -H "Authorization: Bearer <API_TOKEN>" \
  http://<grafana-url>/api/dashboards/uid/<DASHBOARD_UID> > dashboard.json
```

---

## 7. Re-Import the Saved JSON (Optional)

To import the saved dashboard JSON file:

1. Go to **Dashboards → Import**.
2. Click **Upload JSON File**.
3. Select your saved file (e.g., `node_exporter_dashboard.json`).
4. Choose the data source and click **Import**.

---

## 8. Example: Import Node Exporter Dashboard

* **Dashboard ID:** `1860`
* **Steps:**

  1. Copy `1860` from [Node Exporter Full Dashboard](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
  2. In Grafana → Dashboards → Import → Paste `1860`
  3. Click **Load**
  4. Choose **Prometheus** as the data source
  5. Click **Import**

Now you can monitor:

* CPU Usage
* Memory Consumption
* Disk Space
* Network I/O

---

## 9. Best Practices

* Always check the dashboard version and compatibility with your Grafana version.
* Rename imported dashboards to match your environment (e.g., `Production Cluster Metrics`).
* Store downloaded JSON files in Git for version control.
* Regularly update dashboards to the latest version for new panels and bug fixes.

---

## ✅ Summary

You’ve learned how to:

* Browse Grafana dashboards online
* Copy a dashboard ID and import it
* Save and re-import dashboards using JSON files

This is the fastest way to get production-ready visualizations in Grafana without manually building panels.

---

Would you like me to include a sample `Node Exporter Full` JSON export in this document for quick reference?
