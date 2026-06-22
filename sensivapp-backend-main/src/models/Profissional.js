const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Usuario = require('./Usuario');

const Profissional = sequelize.define('Profissional', {
    id_usuario: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        references: {
            model: Usuario,
            key: 'id_usuario'
        }
    },
    registro_profissional: {
        type: DataTypes.STRING(50),
        allowNull: false,
        unique: true 
    },
    especialidade: {
        type: DataTypes.STRING(100),
        allowNull: false
    }
}, {
    tableName: 'Profissionais', 
    timestamps: false
});

// Relacionamentos
Usuario.hasOne(Profissional, { foreignKey: 'id_usuario', onDelete: 'CASCADE' });
Profissional.belongsTo(Usuario, { foreignKey: 'id_usuario' });

module.exports = Profissional;