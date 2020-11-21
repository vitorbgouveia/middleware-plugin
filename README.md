<p align="center">
  <a href="https://www.lua.org/portugues.html" target="blank"><img src="https://www.lua.org/images/luaa.gif" width="320" alt="Nest Logo" /></a>
</p>

middleware-plugin
=========================
* O plugin middleware-plugin foi criado para servir como mais uma camada do API gateway kong.
* O plugin foi criado para servir a api do kong.
* Ao adicionar o plugin a uma rota, ele fará uma requisão após a execução do plugin jwt padrão do kong.
* A requisão feita será construída de acordo com os parâmetros informados ao adicionar o plugins.

- Contruído baseado em Lua 

## Sumário
* [Começando](#começando)
* [Pré-requisitos](#Pré-requisitos)
* [Instalando](#Instalando)
* [Estrutura de código](#Padronização-de-codigo)

## Começando

### Pré-requisitos

* kong
* konga

### Instalando

Navegar até o caminho dentro do kong api
```
cd /usr/local/kong/plugins
```

Clonar o repositório
```
git clone https://github.com/vitorbgouveia/middleware-plugin.git
```

Para realizar o build do plugin:
```
luarocks make
```

Para ativar o plugin deverá alterar a linha do arquivo kong.conf conforme exemplo
```
plugins = bundled, middleware-plugin
```

# Estrutura de código

```
|-- README.md
|-- LICENSE
|-- middleware-plugin-1.0.0-1.rockspec
|-- kong
|   |-- plugins
|   |   |-- middleware-plugin
|   |   |    -- handler.lua
|   |   |    -- json.lua
|   |   |    -- schema.lua
```
