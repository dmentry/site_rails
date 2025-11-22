$(document).ready(function() {
  initHashtagsSystem();

  // Копирование хэштегов в буфер
  $("[data-hss]").on("click", function(event) {
    let hss = this.getAttribute('data-hss');

    navigator.clipboard.writeText(hss);
  })
});

function initHashtagsSystem() {
  let $hashtagInput = $('#hashtag-input');
  let $hashtagsContainer = $('#hashtags-container');
  let $hiddenInput = $('#entity_hashtag_names');

  if (!$hashtagInput.length || !$hashtagsContainer.length || !$hiddenInput.length) {
    return;
  }

  // Инициализация Select2
  $hashtagInput.select2({
    tags: true, // Разрешаем создание новых тегов
    tokenSeparators: [',', ' '], // Разделители для добавления тегов
    placeholder: 'Введите хэштег или выберите из списка...',
    allowClear: false,
    multiple: false, // Одиночный выбор, но с tags: true можно добавлять несколько
    ajax: {
      url: '/hashtags/index_autocomplete',
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          q: params.term
        };
      },
      processResults: function (data) {
        return {
          results: $.map(data, function (item) {
            return {
              id: item.name,
              text: '#' + item.name
            };
          })
        };
      },
      cache: true
    },
    createTag: function (params) {
      let term = params.term.trim();

      if (term === '') {
        return null;
      }

      // Проверяем, нет ли уже такого хэштега в выпадающем списке
      let exists = $(this).find('option').filter(function () {
        return $(this).text().toLowerCase() === ('#' + term.toLowerCase());
      }).length > 0;

      if (exists) {
        return null;
      }

      return {
        id: term,
        text: '#' + term,
        isNew: true
      };
    }
  });

  // Обработчик выбора/добавления хэштега
  $hashtagInput.on('select2:select', function (e) {
    let data = e.params.data;
    
    if (data.isNew) {
      // Новый хэштег
      addHashtag(data.id);
    } else {
      // Существующий хэштег
      addHashtag(data.id);
    }
    
    // Очищаем поле после добавления
    $hashtagInput.val(null).trigger('change');
  });

  // Обработка Enter в поле (на всякий случай)
  $hashtagInput.on('keydown', function(e) {
    if (e.keyCode === 13) { // Enter
      e.preventDefault();

      let value = $(this).val();

      if (value && value.trim().length > 0) {
        addHashtag(value.trim());
        $(this).val(null).trigger('change');
      }
    }
  });

  // Инициализация существующих хэштегов
  initializeExistingHashtags();

  // Функция добавления хэштега
  function addHashtag(tagName) {
    let normalizedName = normalizeHashtagName(tagName);
    
    if (normalizedName.length === 0) {
      return;
    }

    // Проверяем, нет ли уже такого хэштега
    if (isHashtagExists(normalizedName)) {
      highlightDuplicateHashtag(normalizedName);
      return;
    }

    // Создаем элемент хэштега
    let $tagElement = $('<span>', {
      class: 'hashtag_badge hashtag-tag margin_r_2',
      'data-tag-name': normalizedName,
      html: `#${normalizedName}  <button type="button" class="btn-close btn-close-white ml-1 btn btn-light">❌</button>`
    });

    // Добавляем обработчик удаления
    $tagElement.find('.btn-close').on('click', function() {
      removeHashtag($(this).closest('.hashtag-tag'));
    });

    $hashtagsContainer.append($tagElement);
    updateHiddenInput();
    
    // Анимация добавления
    $tagElement.hide().fadeIn(300);
  }

  // Функция удаления хэштега
  function removeHashtag($tagElement) {
    $tagElement.fadeOut(300, function() {
      $(this).remove();
      updateHiddenInput();
    });
  }

  // Проверка существования хэштега
  function isHashtagExists(tagName) {
    return $hashtagsContainer.find(`[data-tag-name="${tagName}"]`).length > 0;
  }

  // Подсветка дубликата хэштега
  function highlightDuplicateHashtag(tagName) {
    let $duplicateTag = $hashtagsContainer.find(`[data-tag-name="${tagName}"]`);
    
    $duplicateTag
      .addClass('bg-warning text-dark')
      .css('transform', 'scale(1.05)');
    
    setTimeout(function() {
      $duplicateTag
        .removeClass('bg-warning text-dark')
        .css('transform', 'scale(1)');
    }, 1000);
  }

  // Нормализация имени хэштега
  function normalizeHashtagName(name) {
    return name.replace(/[#\s,]/g, '_').toLowerCase();
  }

  // Обновление скрытого поля
  function updateHiddenInput() {
    let tagNames = $hashtagsContainer.find('.hashtag-tag')
      .map(function() {
        return $(this).data('tag-name');
      })
      .get()
      .join(',');

    $hiddenInput.val(tagNames);
    $hiddenInput.trigger('change');
  }

  // Инициализация существующих хэштегов
  function initializeExistingHashtags() {
    let existingTags = $hiddenInput.val();
    
    if (existingTags && existingTags.length > 0) {
      let tagsArray = existingTags.split(',');
      
      $hashtagsContainer.empty();
      
      $.each(tagsArray, function(index, tagName) {
        let trimmedTag = tagName.trim();
        if (trimmedTag.length > 0) {
          addHashtag(trimmedTag);
        }
      });
    }
  }
}

// Обработчик удаления хэштегов
$(document).on('click', '.hashtag-tag .btn-close', function() {
  let $tag = $(this).closest('.hashtag-tag');

  $tag.fadeOut(300, function() {
    $(this).remove();

    let $container = $('#hashtags-container');
    let $hiddenInput = $('#entity_hashtag_names');
    
    if ($container.length && $hiddenInput.length) {
      let tagNames = $container.find('.hashtag-tag')
        .map(function() {
          return $(this).data('tag-name');
        })
        .get()
        .join(',');
      
      $hiddenInput.val(tagNames).trigger('change');
    }
  });
});
