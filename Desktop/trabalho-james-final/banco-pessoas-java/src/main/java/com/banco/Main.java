package com.banco;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Scanner;

import org.neo4j.driver.Session;

import com.banco.create_tabela.CriarTabelasPostgres;
import com.banco.database.ConexaoMongo;
import com.banco.database.ConexaoNeo4j;
import com.banco.database.ConexaoPostgres;
import com.banco.database.ConexaoRedis;
import com.banco.model.Pessoa;
import com.banco.repository.PessoaNeo4jGraph;
import com.banco.services.PessoaService;

import redis.clients.jedis.Jedis;

public class Main {
    public static void main(String[] args) {
        // --- Testes de conexão com os bancos de dados ---
        try (Session session = ConexaoNeo4j.getSession()) {
            String msg = session.run("RETURN 'Conectado ao Neo4j com sucesso!' AS msg")
                                .single().get("msg").asString();
            System.out.println(" " + msg);
        } catch (Exception e) {
            System.err.println(" Erro ao conectar no Neo4j: " + e.getMessage());
        }

        try {
            var db = ConexaoPostgres.getConnection();
            System.out.println(" Conectado ao PostgreSQL com sucesso!");
            db.close(); // Fechar a conexão de teste
        } catch (Exception e) {
            System.err.println(" Erro ao conectar no PostgreSQL: " + e.getMessage());
        }

        try {
            var mongo = ConexaoMongo.getDatabase();
            System.out.println(" Conectado ao MongoDB com sucesso!");
        } catch (Exception e) {
            System.err.println(" Erro ao conectar no MongoDB: " + e.getMessage());
        }

        try (Jedis redis = ConexaoRedis.getConnection()) {
            if ("PONG".equalsIgnoreCase(redis.ping())) {
                System.out.println(" Conectado ao Redis com sucesso!");
                redis.set("ultima_acao", "Sistema iniciado");
            }
        } catch (Exception e) {
            System.err.println(" Erro ao conectar no Redis: " + e.getMessage());
        }

        // --- Inicialização dos serviços e repositórios ---
        Scanner scanner = new Scanner(System.in);
        PessoaService service = new PessoaService();
        PessoaNeo4jGraph grafo = new PessoaNeo4jGraph();
        CriarTabelasPostgres create = new CriarTabelasPostgres();

        // Garante que a tabela de pessoas exista no PostgreSQL
        create.criarTabelaPessoa();

        String opcao = "";

        // --- Loop principal do menu ---
        while (!opcao.equals("0")) {
            exibirMenu();
            System.out.print("Escolha uma opção: ");
            opcao = scanner.nextLine();

            switch (opcao) {
                case "1": // Salvar/Atualizar Pessoa
                    System.out.println(">>> CADASTRAR/ATUALIZAR PESSOA <<<");
                    System.out.print("Digite o ID da pessoa (deixe em branco para novo cadastro): ");
                    String idStr = scanner.nextLine();
                    Long idParaSalvar = null;
                    if (!idStr.isEmpty()) {
                        try {
                            idParaSalvar = Long.parseLong(idStr);
                        } catch (NumberFormatException e) {
                            System.out.println("ID inválido. Por favor, digite um número ou deixe em branco.");
                            continue; // Volta para o menu
                        }
                    }

                    Pessoa pessoa = new Pessoa();
                    if (idParaSalvar != null) {
                        pessoa = service.buscarPessoa(idParaSalvar); // Tenta buscar para atualização
                        if (pessoa == null) {
                            pessoa = new Pessoa(); // Se não encontrou, é um novo cadastro com ID especificado
                            pessoa.setId(idParaSalvar);
                            System.out.println("Pessoa com ID " + idParaSalvar + " não encontrada para atualização. Criando nova pessoa com este ID.");
                        } else {
                            System.out.println("Pessoa encontrada para atualização: " + pessoa.getNome());
                        }
                    }

                    // Se o ID ainda for nulo (novo cadastro sem ID inicial), pede um ID
                    if (pessoa.getId() == null) {
                         System.out.print("Digite um ID para a nova pessoa (obrigatório para o exemplo): ");
                         String newIdInput = scanner.nextLine();
                         try {
                             pessoa.setId(Long.parseLong(newIdInput));
                         } catch (NumberFormatException e) {
                             System.out.println("ID fornecido inválido. Não foi possível criar a pessoa.");
                             continue; // Volta para o menu
                         }
                    }

                    System.out.print("Nome: ");
                    pessoa.setNome(scanner.nextLine());
                    System.out.print("Email: ");
                    pessoa.setEmail(scanner.nextLine());
                    System.out.print("CPF: ");
                    pessoa.setCpf(scanner.nextLine());

                    LocalDate dataNascimento = null;
                    boolean dataValida = false;
                    while (!dataValida) {
                        System.out.print("Data de Nascimento (YYYY-MM-DD): ");
                        String dataNascimentoStr = scanner.nextLine();
                        try {
                            dataNascimento = LocalDate.parse(dataNascimentoStr);
                            pessoa.setDataNascimento(dataNascimento); // Agora setDataNascimento aceita LocalDate
                            dataValida = true;
                        } catch (DateTimeParseException e) {
                            System.out.println("Formato de data inválido. UsebeginPath-MM-DD.");
                        }
                    }
                    
                    service.salvarPessoa(pessoa);
                    // Também cria ou atualiza a pessoa no grafo Neo4j
                    grafo.criarPessoaSeNaoExistir(pessoa.getId(), pessoa.getNome());
                    System.out.println(">>> Pessoa salva/atualizada com sucesso! <<<");
                    break;

                case "2": // Buscar Pessoa por ID
                    System.out.println(">>> BUSCAR PESSOA <<<");
                    System.out.print("Digite o ID da pessoa que deseja buscar: ");
                    try {
                        Long idParaBuscar = Long.parseLong(scanner.nextLine());
                        Pessoa pessoaBuscada = service.buscarPessoa(idParaBuscar);
                        if (pessoaBuscada != null) {
                            System.out.println("--- Dados da Pessoa ---");
                            System.out.println("ID: " + pessoaBuscada.getId());
                            System.out.println("Nome: " + pessoaBuscada.getNome());
                            System.out.println("Email: " + pessoaBuscada.getEmail());
                            System.out.println("CPF: " + pessoaBuscada.getCpf());
                            System.out.println("Data de Nascimento: " + pessoaBuscada.getDataNascimento());
                            System.out.println("-----------------------");
                        } else {
                            System.out.println("Pessoa com ID " + idParaBuscar + " não encontrada.");
                        }
                    } catch (NumberFormatException e) {
                        System.out.println("ID inválido. Por favor, digite um número.");
                    }
                    break;

                case "3": // Deletar Pessoa
                    System.out.println(">>> EXCLUIR PESSOA <<<");
                    System.out.print("Digite o ID da pessoa que deseja excluir: ");
                    try {
                        Long idParaExcluir = Long.parseLong(scanner.nextLine());
                        service.deletarPessoa(idParaExcluir);
                        // Opcional: Adicionar lógica de exclusão no Neo4j se necessário
                        // grafo.deletarPessoa(idParaExcluir); // Assumindo que este método existe em PessoaNeo4jGraph
                    } catch (NumberFormatException e) {
                        System.out.println("ID inválido. Por favor, digite um número.");
                    }
                    break;

                case "4": // Registrar Relacionamento (Neo4j)
                    System.out.println(">>> REGISTRAR RELACIONAMENTO <<<");
                    String respostaRelacionamento = "s"; // Inicia o loop para registrar relacionamentos
                    while (respostaRelacionamento.equalsIgnoreCase("s")) {
                        System.out.println("Qual tipo de relacionamento deseja registrar?");
                        System.out.println("1 - Contato profissional");
                        System.out.println("2 - Membro da família");
                        System.out.println("3 - Companheiro de projeto");
                        System.out.print("Escolha (1, 2 ou 3): ");
                        String tipo = scanner.nextLine();

                        try {
                            System.out.print("ID da primeira pessoa: ");
                            Long id1 = Long.parseLong(scanner.nextLine());

                            System.out.print("Nome da primeira pessoa: ");
                            String nome1 = scanner.nextLine();

                            System.out.print("ID da segunda pessoa: ");
                            Long id2 = Long.parseLong(scanner.nextLine());

                            System.out.print("Nome da segunda pessoa: ");
                            String nome2 = scanner.nextLine();

                            if (tipo.equals("1")) {
                                grafo.criarAmizade(id1, nome1, id2, nome2); 
                                System.out.println("Contato profissional registrado com sucesso!");
                            } else if (tipo.equals("2")) {
                                grafo.criarParentesco(id1, nome1, id2, nome2); 
                                System.out.println("Membro da família registrado com sucesso!");
                            } else if (tipo.equals("3")) {
                                grafo.criarColega(id1, nome1, id2, nome2); 
                                System.out.println("Companheiro de projeto registrado com sucesso!");
                            } else {
                                System.out.println("Tipo inválido, tente novamente.");
                            }
                        } catch (NumberFormatException e) {
                            System.out.println("ID inválido em um dos campos. Por favor, digite números.");
                        } catch (Exception e) {
                            System.err.println("Erro ao registrar relacionamento: " + e.getMessage());
                            e.printStackTrace();
                        }

                        System.out.println("Deseja registrar outro relacionamento? (s/n)");
                        respostaRelacionamento = scanner.nextLine();
                    }
                    break;
                case "0":
                    System.out.println("Saindo do programa...");
                    break;
                default:
                    System.out.println("Opção inválida. Tente novamente.");
            }
            System.out.println("\n"); // Espaçamento para melhor leitura
        }
        scanner.close();
        System.out.println("\nPrograma finalizado.");
    }

    // --- Método para exibir o menu principal ---
    private static void exibirMenu() {
        System.out.println("----- MENU PRINCIPAL -----");
        System.out.println("1. Salvar/Atualizar Pessoa");
        System.out.println("2. Buscar Pessoa por ID");
        System.out.println("3. Excluir Pessoa");
        System.out.println("4. Registrar Relacionamento (Neo4j)");
        System.out.println("0. Sair");
        System.out.println("--------------------------");
    }
}
