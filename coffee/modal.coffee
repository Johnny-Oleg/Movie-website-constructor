->
  throttle = (type,name,obj) ->
    obj = obj or window;

    running = false

    func = ->
      return if running

      running = true;

      requestAnimationFrame ->
        obj.dispatchEvent new CustomEvent name
                
        running = false

    obj.addEventListener type, func

  throttle 'resize', 'optimizedResize'

(obj) ->
	obj = obj or window

	animation = (elem,prop,cb) ->
		count = prop.count
		counter = 0

		if prop.start
			prop.start.forEach (item) => 
				elem.style[item[0]] = item[1]

		allAnimation = []

		prop.anim.forEach ([style, from, to]) =>
			max = Math.max from, to
			min = Math.min from, to
			step = (max - min) / count

			console.log min is to

			allAnimation.push {style, from, to, step, reverse: min is to}

		rafAnimation = ->
			allAnimation.forEach (item) =>
				if item.reverse
					item.from -= item.step;
				else
					item.from += item.step

				elem.style[item.style] = item.from

			counter++

			if counter < count
				requestAnimationFrame rafAnimation
			else
        if prop.end
          prop.end.forEach (item) =>
            elem.style[item[0]] = item[1]

        cb() if cb

		requestAnimationFrame rafAnimation

	obj.animation = animation

init = ->
	document.head.insertAdjacentHTML 'beforeend',
		"""<link type="text/css" rel="stylesheet" href="css/index.css">"""

	overlay = document.createElement 'div'
	overlay.className = 'youtube-modal-overlay'

	document.body.insertAdjacentElement 'beforeend', overlay

	video = document.createElement 'div'
	video.id = 'youtube-modal-container'

	sizeBlockList = [
		[3840, 2160]
		[2560, 1440]
		[1920, 1080]
		[1280, 720]
		[854, 420]
		[640, 360]
		[426, 240]
	]

	sizeVideo = ->
		sizeBlock = sizeBlockList.find (item) => item[0] < window.visualViewport.width or
			sizeBlockList[sizeBlockList.length - 1]

		iframe = document.getElementById 'youtube-modal'

		iframe.width = sizeBlock[0]
		iframe.height = sizeBlock[1]

		video.style.cssText = """
			width: #{sizeBlock[0]}
			height: #{sizeBlock[1]}
      """

	sizeContainer = ->
		wh = window.visualViewport.height
		ww = window.visualViewport.width
		fw = video.style.width
		fh = video.style.height

		video.style.left = (ww - fw) / 2
		video.style.top = (wh - fh) / 2
		overlay.style.height = document.documentElement.clientHeight

	sizeYoutubeModal = =>
		sizeContainer()
		sizeVideo()

	closeYoutubeModal = ->
		animation overlay,
      end: [['display', 'none']]
      anim: [['opacity', 1, 0]]
      count: 20
    ,
    =>
      overlay.textContent = ''

		window.removeEventListener 'optimizedResize', sizeYoutubeModal
		document.removeEventListener 'keyup', closeContainerEsc

	closeContainerEsc = (e) =>
		if e.keyCode is 27
			closeYoutubeModal()

	openYoutubeModal = (e) =>
		target = e.target.closest '.youtube-modal'

		return unless target

		href = target.href
		search = href.includes 'youtube'

		idVideo = if search then href.match(/(\?|&)v=([^&]+)/)[2] else href.match(/(\.be\/)([^&]+)/)[2]

		return if idVideo.length is 0
		
		e.preventDefault()

		animation(overlay,
      start: [['display', 'block']]
      anim: [['opacity', 0, 1]]
      count: 20)

		overlay.insertAdjacentHTML 'beforeend', """
			<div id="youtube-modal-loading">Loading...</div>
			<div id="youtube-modal-close">&#10006;</div>
			<div id="youtube-modal-container">
				<iframe src="http://youtube.com/embed/#{idVideo}" 
					frameborder=0
					id="youtube-modal" 
					allowfullscreen="">
				</iframe>
			</div>
		  """

		sizeVideo()
		sizeContainer()

		window.addEventListener 'optimizedResize', sizeYoutubeModal
		document.addEventListener 'keyup', closeContainerEsc


	overlay.addEventListener 'click', closeYoutubeModal
	document.addEventListener 'click', openYoutubeModal

document.addEventListener 'DOMContentLoaded', init