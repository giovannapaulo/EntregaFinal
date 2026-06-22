const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const LocalConforto = sequelize.define('LocalConforto', {
    id_local: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    id_paciente: { type: DataTypes.INTEGER, allowNull: false },
    nome_local: { type: DataTypes.STRING(100) },
    latitude: { type: DataTypes.DECIMAL(10, 8), allowNull: false },
    longitude: { type: DataTypes.DECIMAL(11, 8), allowNull: false },
    tipo_local: { type: DataTypes.STRING(50) },
    anotacoes: { type: DataTypes.TEXT }
}, { tableName: 'Locais_Conforto', timestamps: false });

module.exports = LocalConforto;