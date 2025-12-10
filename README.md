# AWS Self-Healing Web Server (IaC)

### Deploy do Website do Rotary Club da Guarda

Este projeto demonstra, de ponta a ponta, os fundamentos essenciais para atuação em Cloud e DevOps: criação de rede segura, provisionamento automatizado de servidor web e gestão de estado remoto usando Terraform.  

Foi desenvolvido com foco em boas práticas e em um fluxo de trabalho semelhante ao encontrado em ambientes profissionais.

> **Status do projeto:**  
> A infraestrutura já está totalmente provisionada e funcional.  
> O site será publicado em breve — há um formulário que demandará configuração adicional de backend e banco de dados.


---

## Arquitetura (Resumo)

Toda a infraestrutura foi criada via Terraform na região `us-east-1` (N. Virginia).

### Recursos Provisionados

- **VPC (10.0.0.0/16):** isolamento da rede.
- **Subnet pública + Internet Gateway:** permite acesso à internet para o servidor.
- **Security Group com regras rígidas:**
  - **SSH (porta 22):** liberado apenas para o **IP público atual do administrador** (coletado dinamicamente via `data "http"`).
  - **HTTP/HTTPS:** portas liberadas para acesso público.
- **Instância EC2 (t3.micro):** servidor executando Nginx.
- **Elastic IP:** endereço público fixo, mesmo após recriação da instância.
- **Bucket S3:** backend remoto para o estado do Terraform, com:
  - Versionamento habilitado  
  - Criptografia ativada  
  - S3 Native Locking (sem necessidade de DynamoDB)

---

## 🛠️ Tecnologias e Boas Práticas

| Tecnologia | Uso |
|-----------|-----|
| **AWS** | VPC, EC2, S3, EIP, SG, bootstrapping |
| **Terraform** | IaC para todo o provisionamento |
| **S3 Native Locking** | Evita concorrência no arquivo de estado |
| **user_data.sh** | Instala Nginx e faz o deploy automático via `git clone` |
| **Princípio de Menor Privilégio** | SSH restrito dinamicamente |

---

## ⚙️ Fluxo do Projeto (Bootstrapping)

Este projeto segue um fluxo completo de provisionamento, semelhante ao adotado em ambientes profissionais:

1. **Criação do Backend:**  
   O próprio Terraform cria o bucket S3 que será usado para armazenar o estado remoto, já com versionamento e criptografia.

2. **Provisionamento da Infra:**  
   Rede, subnets, Security Groups, EC2, EIP e permissões de acesso.

3. **Deploy Automático da Aplicação:**  
   O script `user_data.sh` instala dependências, configura o Nginx e faz o deploy do site via `git clone`.

---

## ▶️ Como Executar

```bash
terraform init
terraform fmt
terraform plan
terraform apply
```
## Estrutura do Repositório (Resumo)

```
.
├── .gitignore
├── backend_infra.tf
├── ec2.tf
├── outputs.tf
├── provider.tf
├── security.tf
├── variables.tf
├── versions.tf
├── vpc.tf
├── user_data.sh
└── README.md
```

## Objetivo do Projeto

Além de atender a uma demanda real (hospedagem do site institucional), o foco foi praticar habilidades essenciais para vagas de **Cloud/DevOps Júnior**, incluindo:

- Infraestrutura como Código (IaC)
- Segurança básica em Cloud
- Rede e controles de acesso
- Automação com user_data
- Uso de backend remoto para Terraform
- Provisionamento seguro e reprodutível

---

*Projeto desenvolvido por Reinaldo Del Dotore – 2025*