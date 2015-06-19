# Conceitos Básicos #1 - Trabalhando com Coffee

Eu gosto muito de trabalhar com **Javascript** e principalmente com o **Coffee**, nos meus últimos projetos, trabalhei com coisas bem simples, e é sempre bom voltarmos a simplicidade, pois as vezes trabalhamos em projetos muito complexo dos quais requerem um tratamento com mais camadas em nossa aplicação.

Porém como vamos iniciar nossos conceitos básicos vamos nos atentar a Orientação Objeto com Coffee, trabalhar com os DOMs de nossa interface, trabalhar com jquery para inserir nossos eventos.

Vamos iniciar então nossa primeira classe e vamos fazer um simples widget para nosso front-end.

Vamos Fazer uma simples listagem, como se fosse uma lista de tarefas, adicionar novos itens, concluir e trocar entre colunas.


### Dependências
 - Rails (Para Agilizar nosso desenvolvimento)
 - jQuery
 - Bootstrap
 - Coffescript


Vamos ao nosso HTML, será um pouco complexo, mas vou explicar cada item.

``` html
<section class="container" id="tasks">
  <div class="col-sm-10 col-sm-offset-1">
    <!-- Formulário -->
    <div class="row">
      <h4 class="title-underline">Tarefas</h4>
      <div class="col-sm-8 col-sm-offset-2" id="form_container">
        <h5>Nova Tarefa</h5>
        <div class="from-group">
          <input class="form-task" id="task_title" name="task[title]" placeholder="Tarefa">
        </div>

        <div class="from-group">
          <input class="form-task" id="task_description" name="task[description]" placeholder="Descrição">
        </div>

        <div class="from-group">
          <button class="btn btn-primary btn-xs">Adicionar Tarefa</button>
        </div>
      </div>
    </div>

    <!-- Container das nossas Tasks -->
    <div class="row">    
      <div id="tasks_container">
        <!-- Para fazer em casa -->
        <div class="col-sm-12" >
          <h5>Casa</h5>
          <div id="home_list"></div>
        </div>

        <!-- Para fazer no trabalho -->
        <div class="col-sm-12" >
          <h5>Trabalho</h5>
          <div id="home_list"></div>
        </div>

        <!-- Finalizadas -->
        <div class="col-sm-12" >
          <h5>Finalizadas :)</h5>
          <div id="home_list"></div>
        </div>
      </div>
    </div>  

  </div>
</section>

<!-- 
  Incluindo nosso javascript no final da página
  Motivo: Apenas quero carregar esse javascript nessa página e quanto todos os elementos
  estiverem carregados.
 -->
<%= content_for :javascript do %>
  <%= javascript_include_tag asset_path '/tasks', type: :javascript %>
<% end %>

```

  

``` coffee
class @TaskList
  @run: () -> 
    list = new TaskList
    list.add_new_task()

  add_new_task: () -> 

$ () ->
  TaskList.run()


```

Esse modelo de classe que criei, que uso no meu dia a dia e costumo chamar de runnable, por ser uma classe que tem um método self que inicia o nosso widget.

Inicialmente quero criar uma task, então vamos planejar o nosso método `add_new_task`.

``` coffee
class @TaskList
  add_new_task: () ->
    self = this
    $("#add_new_task").on "click", (event) ->
      destination = $("#task_destination option:selected").val()
      
      params = $(this).parents(".row").find("input").map (index, element) ->
        {name: element.name, value: element.value}

      self.validate(params)                 # valida se os campos estão preenchidos
      self.persist(params)                  # grava os dados no banco de dados
      self.add_element(params, destination) # adiciona o elemento em uma lista escolhida

```

Olhando a implementação acima, e usando o mesmo conceito que eu costumo usar em ruby, __um método realiza apenas uma ação__, vamos a implementação dos métodos `validate`, `persist`, `add_element`.

``` coffee
validate: (params) ->
  for object in params
    if object.value?
      throw "#{object.name.split("[").last.replace("]", "")}, "


```

O meu método para a persistência é dado pelo simples post, pois não preciso fazer muitas coisas nesse momento.

``` coffee
persist: (params) ->
  $.post("/tasks.json", params)
```

Implementação da criação do elemento da lista de uma forma bem simples, criei um template:

```html
<div class="task" id="template" style="display:none;">
  <div class="row">  
    <div class="col-sm-2" class="form">
      <input type="checkbox" class="form-control complete"> 
    </div>
    <div class="col-sm-10" class="text">
      <p class="title"></p>
      <p class="description"></p>
    </div>
  </div>
</div>
```

Inseri os dados no template usando o meu params e inseri no nosso parametro destination.

``` coffee
add_element: (params, destination) ->
  template = $("#template").clone()
  $(template).find(".title").text(params[0].value)
  $(template).find(".description").text(params[1].value)
  $(template).find(".complete").on "click", (event) -> finishe(this)
  $(destination).append(template)
  $(template).show()
```

E quando termina a minha task ele é inserida na lista de finalizados

``` coffee
finishe = (element) ->
  if $(element).is(":checked")
      current = $(element).parents(".task")
      current.hide()
      $("#done").append(current)
      current.fadeIn("500")
    else
      current = $(element).parents(".task")
      current.hide()
      $(destination).append(current)
      current.fadeIn("500")

```


