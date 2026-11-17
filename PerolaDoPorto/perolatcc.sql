-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 09-Nov-2026 às 20:11
-- Versão do servidor: 10.4.22-MariaDB
-- versão do PHP: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `perolatcc`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `cliente`
--

CREATE TABLE `cliente` (
  `idCliente` int(11) NOT NULL,
  `nomeRazao` varchar(60) NOT NULL,
  `cpfCnpj` varchar(45) NOT NULL,
  `rgIe` varchar(45) DEFAULT NULL,
  `dataNascAbertura` date DEFAULT NULL,
  `numero` varchar(45) DEFAULT NULL,
  `tipo` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `diaria`
--

CREATE TABLE `diaria` (
  `idDiaria` int(11) NOT NULL,
  `valorDiaria` double NOT NULL,
  `descricao` varchar(100) DEFAULT NULL,
  `statusHospedagem` int(11) NOT NULL,
  `valorTotal` double NOT NULL,
  `statusPagamento` int(11) NOT NULL,
  `feitaEm` date NOT NULL,
  `pagaEm` date DEFAULT NULL,
  `usuario_idUsuario` int(11) NOT NULL,
  `cliente_idCliente` int(11) NOT NULL,
  `pendencias_idPendencias` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `diaria_quarto`
--

CREATE TABLE `diaria_quarto` (
  `diaria_idDiaria` int(11) NOT NULL,
  `quarto_idQuarto` int(11) NOT NULL,
  `valorAtual` double NOT NULL,
  `checkIn` date NOT NULL,
  `checkOut` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `diaria_quarto_servico`
--

CREATE TABLE `diaria_quarto_servico` (
  `diaria_quarto_diaria_idDiaria` int(11) NOT NULL,
  `diaria_quarto_quarto_idQuarto` int(11) NOT NULL,
  `servico_idServico` int(11) NOT NULL,
  `valorServicoAtual` double NOT NULL,
  `tipoContratacao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `menu`
--

CREATE TABLE `menu` (
  `idMenu` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `link` varchar(100) NOT NULL,
  `icone` varchar(45) DEFAULT NULL,
  `exibir` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `menu_perfil`
--

CREATE TABLE `menu_perfil` (
  `menu_idMenu` int(11) NOT NULL,
  `perfil_idPerfil` int(11) NOT NULL,
  `menusVinculados` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`menusVinculados`)),
  `menusNaoVinculados` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`menusNaoVinculados`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pendencias`
--

CREATE TABLE `pendencias` (
  `idPendencias` int(11) NOT NULL,
  `descricao` varchar(100) DEFAULT NULL,
  `valor` double NOT NULL,
  `dataRegistro` date NOT NULL,
  `status` int(11) NOT NULL,
  `diaria_quarto_servico_diaria_diaria_idDiaria` int(11) DEFAULT NULL,
  `diaria_quarto_servico_diaria_quarto_diaria_quarto_idDiaria` int(11) DEFAULT NULL,
  `diaria_quarto_servico_servico_idServico` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `perfil`
--

CREATE TABLE `perfil` (
  `idPerfil` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `quarto`
--

CREATE TABLE `quarto` (
  `idQuarto` int(11) NOT NULL,
  `numero` int(11) NOT NULL,
  `tipo` int(11) NOT NULL,
  `descricao` varchar(100) DEFAULT NULL,
  `valor` double NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `servico`
--

CREATE TABLE `servico` (
  `idServico` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `valor` double NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `login` varchar(45) NOT NULL,
  `senha` varchar(45) NOT NULL,
  `dataNasc` date DEFAULT NULL,
  `status` int(11) NOT NULL,
  `perfil_idPerfil` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idCliente`),
  ADD UNIQUE KEY `cpfCnpj` (`cpfCnpj`);

--
-- Índices para tabela `diaria`
--
ALTER TABLE `diaria`
  ADD PRIMARY KEY (`idDiaria`),
  ADD KEY `usuario_idUsuario` (`usuario_idUsuario`),
  ADD KEY `cliente_idCliente` (`cliente_idCliente`),
  ADD KEY `pendencias_idPendencias` (`pendencias_idPendencias`);

--
-- Índices para tabela `diaria_quarto`
--
ALTER TABLE `diaria_quarto`
  ADD PRIMARY KEY (`diaria_idDiaria`,`quarto_idQuarto`),
  ADD KEY `quarto_idQuarto` (`quarto_idQuarto`);

--
-- Índices para tabela `diaria_quarto_servico`
--
ALTER TABLE `diaria_quarto_servico`
  ADD PRIMARY KEY (`diaria_quarto_diaria_idDiaria`,`diaria_quarto_quarto_idQuarto`,`servico_idServico`),
  ADD KEY `servico_idServico` (`servico_idServico`);

--
-- Índices para tabela `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`idMenu`);

--
-- Índices para tabela `menu_perfil`
--
ALTER TABLE `menu_perfil`
  ADD PRIMARY KEY (`menu_idMenu`,`perfil_idPerfil`),
  ADD KEY `perfil_idPerfil` (`perfil_idPerfil`);

--
-- Índices para tabela `pendencias`
--
ALTER TABLE `pendencias`
  ADD PRIMARY KEY (`idPendencias`);

--
-- Índices para tabela `perfil`
--
ALTER TABLE `perfil`
  ADD PRIMARY KEY (`idPerfil`);

--
-- Índices para tabela `quarto`
--
ALTER TABLE `quarto`
  ADD PRIMARY KEY (`idQuarto`);

--
-- Índices para tabela `servico`
--
ALTER TABLE `servico`
  ADD PRIMARY KEY (`idServico`);

--
-- Índices para tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `login` (`login`),
  ADD KEY `perfil_idPerfil` (`perfil_idPerfil`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idCliente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `diaria`
--
ALTER TABLE `diaria`
  MODIFY `idDiaria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `menu`
--
ALTER TABLE `menu`
  MODIFY `idMenu` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pendencias`
--
ALTER TABLE `pendencias`
  MODIFY `idPendencias` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `perfil`
--
ALTER TABLE `perfil`
  MODIFY `idPerfil` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `quarto`
--
ALTER TABLE `quarto`
  MODIFY `idQuarto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `servico`
--
ALTER TABLE `servico`
  MODIFY `idServico` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `diaria`
--
ALTER TABLE `diaria`
  ADD CONSTRAINT `diaria_ibfk_1` FOREIGN KEY (`usuario_idUsuario`) REFERENCES `usuario` (`idUsuario`),
  ADD CONSTRAINT `diaria_ibfk_2` FOREIGN KEY (`cliente_idCliente`) REFERENCES `cliente` (`idCliente`),
  ADD CONSTRAINT `diaria_ibfk_3` FOREIGN KEY (`pendencias_idPendencias`) REFERENCES `pendencias` (`idPendencias`);

--
-- Limitadores para a tabela `diaria_quarto`
--
ALTER TABLE `diaria_quarto`
  ADD CONSTRAINT `diaria_quarto_ibfk_1` FOREIGN KEY (`diaria_idDiaria`) REFERENCES `diaria` (`idDiaria`) ON DELETE CASCADE,
  ADD CONSTRAINT `diaria_quarto_ibfk_2` FOREIGN KEY (`quarto_idQuarto`) REFERENCES `quarto` (`idQuarto`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `diaria_quarto_servico`
--
ALTER TABLE `diaria_quarto_servico`
  ADD CONSTRAINT `diaria_quarto_servico_ibfk_1` FOREIGN KEY (`diaria_quarto_diaria_idDiaria`,`diaria_quarto_quarto_idQuarto`) REFERENCES `diaria_quarto` (`diaria_idDiaria`, `quarto_idQuarto`) ON DELETE CASCADE,
  ADD CONSTRAINT `diaria_quarto_servico_ibfk_2` FOREIGN KEY (`servico_idServico`) REFERENCES `servico` (`idServico`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `menu_perfil`
--
ALTER TABLE `menu_perfil`
  ADD CONSTRAINT `menu_perfil_ibfk_1` FOREIGN KEY (`menu_idMenu`) REFERENCES `menu` (`idMenu`) ON DELETE CASCADE,
  ADD CONSTRAINT `menu_perfil_ibfk_2` FOREIGN KEY (`perfil_idPerfil`) REFERENCES `perfil` (`idPerfil`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`perfil_idPerfil`) REFERENCES `perfil` (`idPerfil`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
