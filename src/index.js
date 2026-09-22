const express = require('express');
const db = require('./config/db');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Endpoint de verificación
app.get('/', (req, res) => {
  res.json({
    sistema: 'PharmaSys API - Backend Transaccional',
    estado: 'En línea',
    fase: 'Fase 3 - Estructura de Datos y Backend Inicial'
  });
});

app.get('/api/test-db', async (req, res) => {
  try {
    const result = await db.query('SELECT current_database(), current_timestamp;');
    res.json({
      mensaje: 'Conexión a la Base de Datos verificada con éxito',
      datos: result.rows[0]
    });
  } catch (error) {
    res.status(500).json({
      error: 'Error de conexión con la base de datos',
      detalle: error.message
    });
  }
});

app.listen(PORT, () => {
  console.log(`Servidor PharmaSys corriendo en el puerto ${PORT}`);
});
  console.log(`Servidor PharmaSys corriendo en el puerto ${PORT}`);
});
