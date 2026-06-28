# Ninho Consultoria — Diagnostico de Aptidao Financeira

Questionario de diagnostico financeiro com cadastro de pessoas, link individual por pessoa, e painel administrativo. HTML/CSS/JS puro (sem framework, sem build), usando [Supabase](https://supabase.com) como banco de dados e autenticacao.

## Estrutura do projeto

```
Ninho_Consultoria/
├── questionario.html   → formulario que a pessoa responde (via link pessoal)
├── admin.html          → painel: cadastra pessoas, gera links, mostra respostas
├── schema.sql           → script de criacao das tabelas no Supabase
└── README.md
```

## Como funciona

### 1. Voce cadastra uma pessoa no admin
Em `admin.html`, aba **Pessoas**, preenche nome e e-mail, clica em "Cadastrar e gerar link". O sistema cria um token unico e aleatorio para essa pessoa.

### 2. Voce envia o link pessoal dela
Cada pessoa cadastrada aparece na tabela com um link no formato:
```
questionario.html?token=abc123...
```
Voce copia esse link (botao "Copiar") e manda manualmente (WhatsApp, e-mail, etc.). **Envio automatico por e-mail ainda nao esta implementado** — fica como proximo passo.

### 3. A pessoa responde
Ao abrir o link dela, o sistema confirma o token, mostra "Ola, [nome]!" e libera as 7 perguntas. Se o link for invalido ou nao existir, mostra uma tela de erro clara.

### 4. A resposta fica vinculada a pessoa
Cada envio gera um registro na tabela `respostas`, ligado ao `pessoa_id`. Uma mesma pessoa pode responder varias vezes (diagnostico recorrente) — cada resposta fica salva separadamente, e o admin mostra o historico.

### Calculo da pontuacao
Cada pergunta vale de 1 a 4 pontos. Soma total de 7 a 28:
- **22–28** → Gestao Financeira Solida
- **15–21** → Em Desenvolvimento
- **10–14** → Apagando Incendio
- **7–9** → Zona Critica

## Configuracao no Supabase

As credenciais (`SUPA_URL` e `SUPA_KEY`) ja estao preenchidas nos dois arquivos. Falta:

1. Rodar o `schema.sql` no **SQL Editor** do seu projeto Supabase — isso cria as tabelas `pessoas` e `respostas`, com as politicas de seguranca corretas.
2. Criar seu usuario admin em **Authentication → Users** (login que voce usa em `admin.html`).

## Publicar no GitHub Pages

1. Suba `questionario.html`, `admin.html`, `schema.sql` e `README.md` para a raiz do repositorio.
2. Em **Settings → Pages**, Source = branch `main`, pasta `/ (root)`.
3. URLs:
   - Admin: `https://SEU-USUARIO.github.io/SEU-REPO/admin.html`
   - Link de cada pessoa: gerado automaticamente pelo admin, no formato `.../questionario.html?token=...`

## Se for editar algum arquivo direto no GitHub

Para evitar duplicar conteudo por engano:
1. Abra o arquivo, clique no lapis (editar)
2. **Ctrl+A** e **Delete** para limpar tudo antes de colar
3. Cole o conteudo novo por completo
4. Confira que a ultima linha e `</html>`, sem nada repetido depois
5. Commit changes

## Proximos passos possiveis

- Envio automatico de e-mail ao cadastrar uma pessoa (precisa de um servico de envio, ex: Supabase Edge Functions + Resend/SendGrid)
- Mostrar para a pessoa, na tela final, um resumo do proprio resultado
- Excluir pessoa/respostas direto do admin
- Grafico de evolucao por pessoa, quando ela responder mais de uma vez
