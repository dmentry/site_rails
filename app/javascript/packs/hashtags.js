$(document).ready(function() {
  // Инициализация системы хэштегов
  initHashtagsSystem();
});

// Также инициализируем при каждом обновлении DOM на случай динамической загрузки
$(function() {
  initHashtagsSystem();
});

function initHashtagsSystem() {
  let $hashtagInput = $('#hashtag-input');
  let $hashtagsContainer = $('#hashtags-container');
  let $hiddenInput = $('#entity_hashtag_names');

  // Если элементы не найдены, выходим
  if (!$hashtagInput.length || !$hashtagsContainer.length || !$hiddenInput.length) {
    return;
  }

  // Инициализация автодополнения
  $hashtagInput.autocomplete({
    source: function(request, response) {
      $.ajax({
        url: '/hashtags',
        dataType: 'json',
        data: {
          q: request.term
        },
        success: function(data) {
          response($.map(data, function(item) {
            return {
              label: '#' + item.name,
              value: item.name,
              id: item.id
            };
          }));
        },
        error: function(xhr, status, error) {
          console.error('Error fetching hashtags:', error);
          response([]);
        }
      });
    },
    minLength: 2,
    delay: 300,
    select: function(event, ui) {
      event.preventDefault();
      addHashtag(ui.item.value);
      $hashtagInput.val('').focus();
      return false;
    },
    focus: function(event, ui) {
      event.preventDefault();
      $hashtagInput.val(ui.item.value);
      return false;
    }
  });

  // Обработка нажатия клавиш
  $hashtagInput.on('keydown', function(e) {
    let keyCode = e.keyCode || e.which;
    let value = $(this).val().trim();

    // Enter (13) или запятая (188)
    if (keyCode === 13 || keyCode === 188) {
      e.preventDefault();
      
      if (value.length > 0) {
        addHashtag(value.replace(',', ''));
        $(this).val('');
      }
    }
  });

  // Обработка потери фокуса
  $hashtagInput.on('blur', function() {
    const value = $(this).val().trim();
    if (value.length > 0) {
      addHashtag(value);
      $(this).val('');
    }
  });

  // Инициализация существующих хэштегов
  initializeExistingHashtags();

  // Функция добавления хэштега
  function addHashtag(tagName) {
    const normalizedName = normalizeHashtagName(tagName);
    
    if (normalizedName.length === 0) {
      return;
    }

    // Проверяем, нет ли уже такого хэштега
    if (isHashtagExists(normalizedName)) {
      highlightDuplicateHashtag(normalizedName);
      return;
    }

    // Создаем элемент хэштега
    const $tagElement = $('<span>', {
      class: 'badge badge-info hashtag-tag mr-1',
      'data-tag-name': normalizedName,
      html: `#${normalizedName} <button type="button" class="btn-close btn-close-white ml-1 btn btn-light">❎</button>`
    });

    // Добавляем обработчик удаления
    $tagElement.find('.btn-close').on('click', function() {
      removeHashtag($(this).closest('.hashtag-tag'));
    });

    $hashtagsContainer.append($tagElement);
    updateHiddenInput();
    
    // Показываем анимацию добавления
    $tagElement.hide().fadeIn(300);
  }

  // Функция удаления хэштега
  function removeHashtag($tagElement) {
    $tagElement.fadeOut(300, function() {
      $(this).remove();
      updateHiddenInput();
    });
  }

  // Удаление последнего хэштега
  function removeLastHashtag() {
    const $lastTag = $hashtagsContainer.children('.hashtag-tag').last();
    if ($lastTag.length) {
      removeHashtag($lastTag);
    }
  }

  // Проверка существования хэштега
  function isHashtagExists(tagName) {
    return $hashtagsContainer.find(`[data-tag-name="${tagName}"]`).length > 0;
  }

  // Подсветка дубликата хэштега
  function highlightDuplicateHashtag(tagName) {
    const $duplicateTag = $hashtagsContainer.find(`[data-tag-name="${tagName}"]`);
    
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
    const tagNames = $hashtagsContainer.find('.hashtag-tag')
      .map(function() {
        return $(this).data('tag-name');
      })
      .get()
      .join(',');

    $hiddenInput.val(tagNames);
    
    // Триггерим событие изменения для возможных других скриптов
    $hiddenInput.trigger('change');
  }

  // Инициализация существующих хэштегов
  function initializeExistingHashtags() {
    const existingTags = $hiddenInput.val();
    
    if (existingTags && existingTags.length > 0) {
      const tagsArray = existingTags.split(',');
      
      // Очищаем контейнер перед инициализацией
      $hashtagsContainer.empty();
      
      $.each(tagsArray, function(index, tagName) {
        const trimmedTag = tagName.trim();
        if (trimmedTag.length > 0) {
          addHashtag(trimmedTag);
        }
      });
    }
  }
}

// Глобальные функции для работы с хэштегами
// Могут быть вызваны из других скриптов
window.Hashtags = {
  // Добавить хэштег программно
  add: function(tagName) {
    const $hashtagInput = $('#hashtag-input');
    if ($hashtagInput.length) {
      // Используем существующую логику
      $hashtagInput.val(tagName).trigger('blur');
    }
  },
  
  // Очистить все хэштеги
  clear: function() {
    $('#hashtags-container').empty();
    $('#entity_hashtag_names').val('');
  },
  
  // Получить текущие хэштеги
  getTags: function() {
    const $hiddenInput = $('#entity_hashtag_names');
    return $hiddenInput.val() ? $hiddenInput.val().split(',') : [];
  }
};

// Обработчик для динамически добавленных элементов
$(document).on('click', '.hashtag-tag .btn-close', function() {
  const $tag = $(this).closest('.hashtag-tag');
  $tag.fadeOut(300, function() {
    $(this).remove();
    updateHashtagHiddenInput();
  });
});

// Функция обновления hidden input (глобальная)
function updateHashtagHiddenInput() {
  const $container = $('#hashtags-container');
  const $hiddenInput = $('#entity_hashtag_names');
  
  if ($container.length && $hiddenInput.length) {
    const tagNames = $container.find('.hashtag-tag')
      .map(function() {
        return $(this).data('tag-name');
      })
      .get()
      .join(',');
    
    $hiddenInput.val(tagNames).trigger('change');
  }
}

// Реинициализация при AJAX запросах (если используется)
$(document).ajaxComplete(function() {
  // Проверяем, есть ли на странице элементы для хэштегов
  if ($('#hashtag-input').length && !$('#hashtag-input').hasClass('ui-autocomplete-input')) {
    initHashtagsSystem();
  }
});
