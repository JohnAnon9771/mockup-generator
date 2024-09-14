# MockupGenerator

MockupGenerator é uma ferramenta em Ruby que gera mockups realistas a partir de templates, máscaras e artes gráficas usando a biblioteca RMagick.

## Índice

- [Características](#características)
- [Requisitos](#requisitos)
- [Instalação](#instalação)
- [Uso](#uso)
- [Exemplos](#exemplos)
- [Resultados](#resultados)
- [Contribuição](#contribuição)
- [Licença](#licença)
- [Contato](#contato)

## Características

- Gera mapas de ajuste, deslocamento e iluminação para criar mockups realistas.
- Suporta personalização de templates e artes gráficas.
- Utiliza algoritmos para calcular o brilho médio e ajustar o mockup de acordo.

## Requisitos

- Ruby (versão 2.5 ou superior)
- Gem `rmagick`
- ImageMagick instalado no sistema

## Instalação

1. **Instale o ImageMagick** no seu sistema:

   - **macOS**:

     ```bash
     brew install imagemagick
     ```

   - **Ubuntu/Debian**:

     ```bash
     sudo apt-get install imagemagick
     ```

2. **Instale a gem RMagick**:

   ```bash
   gem install rmagick
   ```

3. **Clone o repositório**:

   ```bash
   git clone https://github.com/JohnAnon9771/MockupGenerator.git
   ```

4. **Navegue até o diretório do projeto**:

   ```bash
   cd MockupGenerator
   ```

## Uso

```ruby
require 'rmagick'
require './mockup_generator'

# Caminhos para os arquivos
template = "/caminho/para/template.jpg"
mask = "/caminho/para/mask.png"
artwork = "/caminho/para/artwork.png"

# Inicializa o gerador de mockups
generator = MockupGenerator.new(template, mask, artwork)

# Gera o mockup
generator.generate
```

Os arquivos gerados serão salvos no diretório atual:

- `adjustment_map.jpg`
- `displacement_map.png`
- `lighting_map.png`
- `mockup.png`

## Exemplos

### Template

Imagem base onde a arte será aplicada.

![Template](assets/mug/template.jpg)

### Máscara

Define a área onde a arte será posicionada no template.

![Máscara](assets/mug/mask.png)

### Arte

A imagem que será inserida no mockup.

![Arte](assets/mug/artwork.png)

## Resultados

Após executar o script, você obterá um mockup com a arte aplicada de forma realista.

![Mockup Gerado](assets/mug/mockup.png)

## Explicação dos Passos

1. **Geração do Mapa de Ajuste**: Cria um mapa que ajusta o brilho e contraste da arte para combinar com o template.

2. **Geração do Mapa de Deslocamento**: Aplica um efeito de deslocamento para simular a textura e contornos do template na arte.

3. **Geração do Mapa de Iluminação**: Ajusta a iluminação da arte para corresponder à iluminação do template.

4. **Geração do Mockup Final**: Combina todos os mapas e aplica a arte no template, produzindo o mockup final.