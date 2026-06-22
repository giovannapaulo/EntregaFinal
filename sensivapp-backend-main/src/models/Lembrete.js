const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Lembrete = sequelize.define('Lembrete', {
    id_lembrete: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    id_paciente: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'Pacientes', key: 'id_usuario' } },
    titulo: { type: DataTypes.STRING(255), allowNull: false },
    data_hora: { type: DataTypes.DATE, allowNull: false },
    criado_por: { type: DataTypes.STRING(100), defaultValue: 'Você' }
}, { tableName: 'Lembretes', timestamps: false });

module.exports = Lembrete;