class @TaskList
  @run: () -> 
    list = new TaskList
    list.add_new_task()

  add_new_task: () ->
    self = this
    $("#add_new_task").on "click", (event) ->
      try
        destination = $("#task_destination option:selected").val()
        
        params = $(this).parents(".row").find("input").map (index, element) ->
          {name: element.name, value: element.value}

        self.validate(params)
        self.persist(params)
        self.add_element(params, destination)
      catch e
        alert(e)

  validate: (params) ->
    for object in params
      if object.value == ""
        attr = object.name.split("[")[1].replace("]", "")
        throw "#{attr}, não pode ficar em branco"


  add_element: (params, destination) ->
    template = $("#template").clone()
    $(template).find(".title").text(params[0].value)
    $(template).find(".description").text(params[1].value)
    $(template).find(".complete").on "click", (event) -> finishe(this)
    $(destination).append(template)
    $(template).show()

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

  persist: (params) ->
    $.post("/tasks.json", params)

$ () ->
  TaskList.run()
