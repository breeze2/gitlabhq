class @ImporterStatus
  constructor: (@jobs_url, @import_url) ->
    this.initStatusPage()
    this.setAutoUpdate()

  initStatusPage: ->
    $('.js-add-to-import')
      .off 'click'
      .on 'click', (e) =>
        new_namespace = null
        $btn = $(e.currentTarget)
        $tr = $btn.closest('tr')
        id = $tr.attr('id').replace('repo_', '')
        if $tr.find('.import-target input').length > 0
          new_namespace = $tr.find('.import-target input').prop('value')
          $tr.find('.import-target').empty().append("#{new_namespace} / #{$tr.find('.import-target').data('project_name')}")

        $btn
          .disable()
          .addClass 'is-loading'

        $.post @import_url, {repo_id: id, new_namespace: new_namespace}, dataType: 'script'

    $('.js-import-all')
      .off 'click'
      .on 'click', (e) ->
        $btn = $(@)
        $btn
          .disable()
          .addClass 'is-loading'

        $('.js-add-to-import').each ->
          $(this).trigger('click')

  setAutoUpdate: ->
    setInterval (=>
      $.get @jobs_url, (data) =>
        $.each data, (i, job) =>
          job_item = $("#project_" + job.id)
          status_field = job_item.find(".job-status")

          if job.import_status == 'finished'
            job_item.removeClass("active").addClass("success")
            status_field.html('<span><i class="fa fa-check"></i> 完成</span>')
          else if job.import_status == 'started'
            status_field.html("<i class='fa fa-spinner fa-spin'></i> 已开始")
          else
            status_field.html(job.import_status)

    ), 4000
