const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Meditacao = sequelize.define('Meditacao', {
    id_meditacao: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    titulo: { type: DataTypes.STRING(150), allowNull: false },
    descricao: { type: DataTypes.TEXT },
    duracao_segundos: { type: DataTypes.INTEGER },
    url_conteudo: { type: DataTypes.STRING(255), allowNull: false }
}, { tableName: 'Meditacoes', timestamps: false });

module.exports = Meditacao;