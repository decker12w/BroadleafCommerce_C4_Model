workspace "Broadleaf Commerce" "Diagramas C4 do sistema de e-commerce Broadleaf Commerce baseado na estrutura real do repositório" {

    model {
        # Pessoas
        customer = person "Cliente" "Usuário que navega e compra produtos no e-commerce"
        admin = person "Administrador" "Gerencia catálogo, pedidos, conteúdo e configurações do sistema"
        developer = person "Desenvolvedor" "Integra aplicações externas via API REST"
        
        # Sistemas Externos
        paymentGateway = softwareSystem "Gateway de Pagamento" "Processa pagamentos com cartão de crédito" "External System"
        shippingProvider = softwareSystem "Provedor de Envio" "Calcula fretes e rastreamento (ex: USPS, FedEx)" "External System"
        taxService = softwareSystem "Serviço de Impostos" "Calcula impostos sobre vendas" "External System"
        emailService = softwareSystem "Serviço de Email" "Envia emails transacionais e promocionais" "External System"
        
        # Sistema Principal
        broadleafSystem = softwareSystem "Broadleaf Commerce" "Sistema de e-commerce empresarial baseado em Java/Spring" {
            
            # Web Layer - Site (Projeto Maven separado)
            siteApp = container "Site Application" "Interface web pública para clientes (projeto Maven site)" "Spring MVC, Thymeleaf" "Web Application" {
                siteControllers = component "Site Controllers" "Controladores MVC para navegação, carrinho, checkout" "Spring MVC"
                thymeleafTemplates = component "Thymeleaf Templates" "Templates HTML para renderização" "Thymeleaf"
                staticContent = component "Static Resources" "CSS, JavaScript, imagens" "Static Files"
            }
            
            # Admin Module (Projeto Maven admin/)
            adminModule = container "Admin Module" "Módulo administrativo do framework (projeto Maven admin/)" "Spring MVC, JavaScript" "Framework Module" {
                adminControllers = component "Admin Controllers" "Controladores base para CRUD de entidades" "Spring MVC"
                adminServices = component "Admin Services" "Serviços de gerenciamento administrativo" "Spring Service"
                adminSecurity = component "Admin Security" "Autenticação e autorização admin" "Spring Security"
                openAdminPlatform = component "Open Admin Platform" "Plataforma extensível para criação de UIs admin" "Java/Spring"
                adminUI = component "Admin UI Components" "Componentes de interface administrativa" "JavaScript, CSS"
                adminAnnotations = component "Admin Presentation Annotations" "Anotações para configurar exibição de entidades" "Java Annotations"
            }
            
            # Common Module (Projeto Maven common/)
            commonModule = container "Common Module" "Componentes e classes compartilhadas (projeto Maven common/)" "Java, Spring" "Framework Module" {
                extensibilityFramework = component "Extensibility Framework" "Suporte a extensão e merge de configurações" "Spring"
                configMerge = component "Configuration Merge" "Merge de arquivos Spring XML/Java Config" "Spring"
                qosMonitoring = component "QoS Monitoring" "Monitoramento de qualidade de serviço" "JMX"
                commonUtilities = component "Common Utilities" "Classes utilitárias compartilhadas" "Java"
                cacheAbstraction = component "Cache Abstraction" "Abstração de cache" "Spring Cache"
                emailSupport = component "Email Support" "Suporte a envio de emails" "Spring/JMS"
            }
            
            # Core Module (Projeto Maven core/)
            coreModule = container "Core Module" "Núcleo do framework com lógica de negócio principal (projeto Maven core/)" "Java, Spring" "Framework Module" {
                # Catalog
                catalogService = component "Catalog Service" "Gerenciamento de produtos, categorias, SKUs" "Spring Service"
                catalogDAO = component "Catalog DAO" "Acesso a dados de catálogo" "JPA/Hibernate"
                
                # Order
                orderService = component "Order Service" "Gerenciamento de pedidos e carrinho" "Spring Service"
                orderDAO = component "Order DAO" "Acesso a dados de pedidos" "JPA/Hibernate"
                
                # Pricing
                pricingService = component "Pricing Service" "Cálculo de preços base" "Spring Service"
                
                # Customer
                customerService = component "Customer Service" "Gerenciamento de clientes e endereços" "Spring Service"
                customerDAO = component "Customer DAO" "Acesso a dados de clientes" "JPA/Hibernate"
                
                # Checkout Workflow
                checkoutService = component "Checkout Service" "Orquestração do fluxo de checkout" "Spring Service"
                workflowEngine = component "Workflow Engine" "Motor de workflows configuráveis" "Spring"
                
                # Offer/Promotion
                offerService = component "Offer Service" "Gerenciamento de ofertas e promoções" "Spring Service"
                promotionEngine = component "Promotion Engine" "Motor de regras promocionais com MVEL" "MVEL"
                
                # Payment
                paymentService = component "Payment Service" "Serviço de processamento de pagamentos" "Spring Service"
                paymentModule = component "Payment Module Interface" "Interface para módulos de pagamento" "Module API"
                
                # Fulfillment
                fulfillmentService = component "Fulfillment Service" "Gerenciamento de fulfillment" "Spring Service"
                shippingModule = component "Shipping Module Interface" "Interface para módulos de envio" "Module API"
                taxModule = component "Tax Module Interface" "Interface para módulos de impostos" "Module API"
                
                # CMS
                cmsService = component "CMS Service" "Gerenciamento de conteúdo e páginas" "Spring Service"
                structuredContentService = component "Structured Content Service" "Conteúdo estruturado com targeting" "Spring Service"
                
                # Domain Model
                domainModel = component "Domain Model" "Entidades JPA principais (Product, Order, Customer, etc)" "JPA Entities"
            }
            
            # Integration Module (Projeto Maven integration/)
            integrationModule = container "Integration Module" "Testes de integração" "JUnit, Spring Test" "Test Module"
            
            # REST API (pode ser separado ou parte do site)
            apiApp = container "REST API" "API RESTful para integrações externas" "Spring REST" "API"
            
            # Search Layer
            searchEngine = container "Search Engine" "Motor de busca e indexação" "Apache Solr" "Search Engine" {
                solrCore = component "Solr Core" "Índices Solr e configurações" "Solr"
                indexService = component "Solr Index Service" "Serviço de indexação de produtos" "Spring"
                searchService = component "Solr Search Service" "Serviço de busca e faceting" "Spring"
                searchFacade = component "Search Facade" "Facade para operações de busca" "Spring"
            }
            
            # Data Layer
            database = container "Database" "Armazena dados de produtos, pedidos, clientes, CMS" "PostgreSQL/MySQL/Oracle" "Database"
            
            # Message Queue
            messageQueue = container "Message Queue" "Processamento assíncrono (emails, indexação)" "JMS/ActiveMQ" "Message Broker"
            
            # Scheduler
            scheduler = container "Task Scheduler" "Tarefas agendadas (limpeza, reindexação)" "Quartz" "Scheduler"
        }
        
        # Relacionamentos - System Context
        customer -> broadleafSystem "Navega catálogo, faz compras"
        admin -> broadleafSystem "Gerencia produtos, pedidos e conteúdo"
        developer -> broadleafSystem "Integra via API REST"
        
        broadleafSystem -> paymentGateway "Processa pagamentos" "HTTPS/REST"
        broadleafSystem -> shippingProvider "Calcula fretes" "HTTPS/REST"
        broadleafSystem -> taxService "Calcula impostos" "HTTPS/REST"
        broadleafSystem -> emailService "Envia emails" "SMTP/API"
        
        # Relacionamentos - Container Level
        customer -> siteApp "Visita via navegador" "HTTPS"
        admin -> siteApp "Acessa área admin" "HTTPS"
        developer -> apiApp "Consome API" "HTTPS/JSON"
        
        # Site App usa Core Module
        siteApp -> coreModule "Usa serviços de negócio" "Java API"
        siteApp -> commonModule "Usa utilitários compartilhados" "Java API"
        
        # Admin é usado pelo Site para renderizar admin UI
        siteApp -> adminModule "Renderiza interface admin" "Java API"
        adminModule -> coreModule "Usa serviços de negócio" "Java API"
        adminModule -> commonModule "Usa utilitários compartilhados" "Java API"
        
        # Core Module dependencies
        coreModule -> commonModule "Usa classes compartilhadas" "Java API"
        coreModule -> database "Persiste dados" "JPA/Hibernate"
        coreModule -> searchEngine "Indexa e busca produtos" "HTTP/REST"
        coreModule -> messageQueue "Publica mensagens" "JMS"
        
        # Admin Module
        adminModule -> database "Lê/Escreve dados admin" "JPA/Hibernate"
        
        # Common Module
        commonModule -> messageQueue "Envia emails via JMS" "JMS"
        commonModule -> emailService "Envia emails" "SMTP"
        
        # Search
        searchEngine -> database "Lê dados para indexação" "JDBC"
        
        # Scheduler
        scheduler -> coreModule "Executa tarefas agendadas" "Java API"
        
        # External integrations
        coreModule -> paymentGateway "Processa pagamentos" "HTTPS"
        coreModule -> shippingProvider "Calcula fretes" "HTTPS"
        coreModule -> taxService "Calcula impostos" "HTTPS"
        
        # API App
        apiApp -> coreModule "Usa serviços de negócio" "Java API"
        
        # Component Relationships - Site App
        siteControllers -> catalogService "Lista produtos/categorias"
        siteControllers -> orderService "Gerencia carrinho"
        siteControllers -> checkoutService "Processa checkout"
        siteControllers -> cmsService "Exibe conteúdo"
        
        # Component Relationships - Admin Module
        adminControllers -> catalogService "CRUD produtos"
        adminControllers -> orderService "Gerencia pedidos"
        adminControllers -> customerService "Gerencia clientes"
        adminControllers -> cmsService "Gerencia conteúdo"
        adminControllers -> offerService "Gerencia promoções"
        openAdminPlatform -> adminAnnotations "Lê configurações de exibição"
        
        # Component Relationships - Core Module
        checkoutService -> workflowEngine "Executa workflow de checkout"
        checkoutService -> pricingService "Calcula preços"
        checkoutService -> offerService "Aplica ofertas"
        checkoutService -> promotionEngine "Avalia regras promocionais"
        checkoutService -> paymentService "Processa pagamento"
        checkoutService -> fulfillmentService "Calcula frete"
        
        paymentService -> paymentModule "Delega para módulo específico"
        fulfillmentService -> shippingModule "Calcula via módulo"
        fulfillmentService -> taxModule "Calcula impostos"
        
        offerService -> promotionEngine "Avalia regras MVEL"
        pricingService -> offerService "Aplica ofertas"
        
        orderService -> workflowEngine "Executa workflows"
        orderService -> orderDAO "Persiste pedidos"
        catalogService -> catalogDAO "Persiste catálogo"
        customerService -> customerDAO "Persiste clientes"
        
        catalogService -> indexService "Indexa produtos no Solr"
        searchService -> solrCore "Consulta índices"
        searchFacade -> searchService "Abstrai operações"
        
        # All services use domain model
        catalogService -> domainModel "Usa entidades"
        orderService -> domainModel "Usa entidades"
        customerService -> domainModel "Usa entidades"
    }

    views {
        # System Context Diagram
        systemContext broadleafSystem "SystemContext" {
            include *
            autoLayout
        }
        
        # Container Diagram - Mostra módulos Maven
        container broadleafSystem "Containers" {
            include *
            autoLayout
        }
        
        # Component Diagram - Core Module (mais importante)
        component coreModule "CoreComponents" {
            include *
            autoLayout
        }
        
        # Component Diagram - Admin Module
        component adminModule "AdminComponents" {
            include *
            autoLayout
        }
        
        # Component Diagram - Common Module
        component commonModule "CommonComponents" {
            include *
            autoLayout
        }
        
        # Component Diagram - Site Application
        component siteApp "SiteComponents" {
            include *
            autoLayout
        }
        
        # Component Diagram - Search Engine
        component searchEngine "SearchComponents" {
            include *
            autoLayout
        }
        
        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "External System" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Framework Module" {
                background #2e7d32
                color #ffffff
            }
            element "Test Module" {
                background #f57c00
                color #ffffff
            }
            element "Web Application" {
                shape WebBrowser
            }
            element "Database" {
                shape Cylinder
            }
            element "Message Broker" {
                shape Pipe
            }
            element "Search Engine" {
                shape Hexagon
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
        }
        
        theme default
    }
    
    configuration {
        scope softwaresystem
    }
}
