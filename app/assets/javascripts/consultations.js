Hippocrates.Consultations = {
  init: function() {
    var self = this;

    $("#show").on("click", function(e) {
      e.preventDefault();
      self.openModal();
    });

    $(".modal").on("show.bs.modal", function (e) {
      self.getLastConsultation(this);
    });

    $("#prev").on("click", function(e) {
      self.getPreviousConsultation();
      return false;
    });

    $("#next").on("click", function(e) {
      self.getNextConsultation();
      return false;
    });

    $("body").keydown(function(e) {
      if (($(".modal").data("bs.modal") || {}).isShown) {
        var LEFT_ARROW = 37, RIGHT_ARROW = 39;
        if(e.keyCode === LEFT_ARROW) {
          self.getPreviousConsultation();
        }
        else if(e.keyCode === RIGHT_ARROW) {
          self.getNextConsultation();
        }
      }
    });
  },

  openModal: function() {
    $(".modal").modal({ backdrop: "static" });
  },

  renderTemplate: function(target, data) {
    var template = $(target).html();
    Mustache.parse(template);
    return Mustache.render(template, data);
  },

  renderConsultation: function(consultation) {
    if (consultation) {
      var consultationHeader = this.renderTemplate("#consultation-header", consultation);
      var consultationBody = this.renderTemplate("#consultation-body", consultation);

      $(".modal").find(".modal-title").html(consultationHeader);
      $(".modal").find(".modal-body").html(consultationBody);
    }
  },

  consultationType: { LAST: "last", PREV: "previous", NEXT: "next" },

  getConsultation: function(type) {
    var self = this;
    var data = {};

    if (type !== this.consultationType.LAST) {
      data = { current_consultation: $("#current-consultation").val() };
    }

    var path = "/api" + $(".container > form").attr("action").replace(/\/\d+$/, "") + "/" + type;
    $.post(path, data, function(consultation) {
      self.renderConsultation(consultation);
    });
  },

  getLastConsultation: function() {
    this.getConsultation(this.consultationType.LAST);
  },

  getPreviousConsultation: function() {
    this.getConsultation(this.consultationType.PREV);
  },

  getNextConsultation: function() {
    this.getConsultation(this.consultationType.NEXT);
  }
};
