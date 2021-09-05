getElement = (tagName, classNames, attrs) =>
	$elem = document.createElement tagName

	classNames and $elem.classList.add classNames...

	if attrs
		for i of attrs
			$elem[i] = attrs[i]

	$elem

createHeader = ({header, title}) =>
	{logo, menu, social} = header
 
	$header = getElement 'header'
	$container = getElement 'div', ['container']
	$wrapper = getElement 'div', ['header']

	if logo
		$logo = getElement 'img', ['logo'],
			src: logo
			alt: "Logo #{title}"

		$wrapper.append $logo

	if menu
		$nav = getElement 'nav', ['menu-list']
		$menuBtn = getElement 'button', ['menu-button']

		menuLink = menu.map ((item) =>
			$link = getElement 'a', ['menu-link'],
				href: item.link
				textContent: item.title

			$link)

		$menuBtn.addEventListener 'click', =>
			$menuBtn.classList.toggle 'menu-button-active'
			$wrapper.classList.toggle 'header-active'
		
		$nav.append menuLink...
		$wrapper.append $nav
		$container.append $menuBtn

	if social
		$socialWrapper = getElement 'div', ['social']

		socialArr = social.map ((item) => 
			$socialLink = getElement 'a', ['social-link'],
				href: item.link

			$socialImg = getElement 'img', [],
				src: item.image
				alt: item.title

			$socialLink.append $socialImg

			$socialLink)

		$socialWrapper.append socialArr...
		$wrapper.append $socialWrapper

	$container.append $wrapper
	$header.append $container

	$header

createMain = ({title, main}) => 
	{ genre, rating, description, trailer, slider } = main

	$main = getElement 'main'
	$container = getElement 'div', ['container']
	$wrapper = getElement 'div', ['main-content']
	$content = getElement 'div', ['content']
	$title = getElement 'h1', ['main-title', 'animated', 'fadeInRight'], 
		textContent: title
	
	$content.append $title
	$wrapper.append $content
	$container.append $wrapper

	if genre
		$genre = getElement 'span', ['genre', 'animated', 'fadeInRight'], 
			textContent: genre

		$content.append $genre

	if rating 
		$block = getElement 'div', ['rating', 'animated', 'fadeInRight']
		$stars = getElement 'div', ['rating-stars', 'animated', 'fadeInRight']
		$number = getElement 'div', ['rating-number', 'animated', 'fadeInRight'],
			textContent: "#{rating}/10"
		
		i = 0
		while i < 10
			$star = getElement 'img', ['star'],
				alt: if i then '' else "Rating #{rating} out of 10"
				src: if i <  rating then 'img/star.svg' else 'img/star-o.svg'

			$stars.append $star
			i++

		$block.append $stars, $number
		$content.append $block

	if description
		$description = getElement 'p', ['main-description', 'animated', 'fadeInRight'],
			textContent: description

		$content.append $description

	if trailer
		$youtubeLink = getElement 'a', [
			'button', 'youtube-modal', 'animated', 'fadeInRight'
		],
			href: trailer
			textContent: 'Watch trailer'

		$youtubeImg = getElement 'a', ['play', 'youtube-modal'],
			href: trailer
			ariaLabel: 'Watch trailer'

		$youtubeIcon = getElement 'img', ['play-img'],
			src: 'img/play.svg'
			alt: ''
			ariaHidden: yes

		$content.append $youtubeLink
		$youtubeImg.append $youtubeIcon
		$wrapper.append $youtubeImg

	if slider
		$slider = getElement 'div', ['series']
		$swiperBlock= getElement 'div', ['swiper-container']
		$swiperWrapper = getElement 'div', ['swiper-wrapper']
		$arrow = getElement 'button', ['arrow']

		slides = slider.map ((item) => 
			$swiper = getElement 'div', ['swiper-slide']
			$card = getElement 'figure', ['card']

			$cardImg = getElement 'img', ['card-img'],
				src: item.img
				alt: ("#{item.title} - " or '') + (item.subtitle or '')

			if item.title or item.subtitle
				$cardDescription = getElement 'figcaption', ['card-description']

				$cardDescription.innerHTML = """
					#{if item.subtitle then "<p class='card-subtitle'>#{item.subtitle}</p>" else ''}
					#{if item.title then "<p class='card-title'>#{item.title}</p>" else ''}
					"""

				$card.append $cardDescription

			$card.append $cardImg
			$swiper.append $card

			$swiper)

		$swiperWrapper.append slides...
		$swiperBlock.append $swiperWrapper 
		$slider.append $swiperBlock, $arrow
		$container.append $slider

		new Swiper($swiperBlock,
			loop: yes,
			navigation: nextEl: $arrow
			breakpoints:
				320:
					slidesPerView: 1
					spaceBetween: 20
				541:
					slidesPerView: 2
					spaceBetween: 40)

	$main.append $container

	$main

createFooter = ({footer}) => 
	{copyright, menu} = footer

	$footer = getElement 'footer', ['footer']
	$container = getElement 'div', ['container']
	$content = getElement 'div', ['footer-content']

	if copyright
		$leftBlock = getElement 'div', ['left']
		$copyright = getElement 'span', ['copyright'],
			textContent: "© #{copyright.year} #{copyright.movie}. All right reserved."

		$leftBlock.append $copyright
		$content.append $leftBlock

	if menu
		$rightBlock = getElement 'div', ['right']
		$nav = getElement 'nav', ['footer-menu']

		menuLink = menu.map ((item) => 
			$link = getElement 'a', ['footer-link'], 
				href: item.link,
				textContent: item.title,
			
			$link)
		
		$nav.append menuLink...
		$rightBlock.append $nav
		$content.append $rightBlock
	
	$container.append $content
	$footer.append $container

	$footer


movieConstructor = (selector, options) =>
	$app = document.querySelector selector

	$app.classList.add 'body-app'

	$app.style.color = options.fontColor
	$app.style.backgroundColor = options.backgroundColor
	$app.style.backgroundImage = if options.background then "url(#{options.background})" else ''
	document.title = options.title

	options.subColor and document.documentElement.style.setProperty '--sub-color', options.subColor

	if options.favicon
		index = options.favicon.lastIndexOf '.'
		type = options.favicon.substring index + 1

		$favicon = getElement 'link', null, 
			rel: 'icon'
			href: options.favicon
			type: "image/#{if type is "svg" then 'svg-xml' else type}"
		

		document.head.append $favicon

	if options.header
		header = createHeader options

		$app.append header

	if options.main
		main = createMain options

		$app.append main

	if options.footer
		footer = createFooter options

		$app.append footer

movieData = 
  title: 'Witcher'
  background: 'witcher/background.jpg'
  favicon: 'witcher/logo.png'
  fontColor: '#FFFFFF'
  backgroundColor: '#141218'
  subColor: '#9D2929'
  header:
    logo: 'witcher/logo.png'
    social: [
      {
        title: 'Twitter'
        link: 'https://twitter.com'
        image: 'witcher/social/twitter.svg'
      }
      {
        title: 'Instagram'
        link: 'https://instagram.com'
        image: 'witcher/social/instagram.svg'
      }
      {
        title: 'Facebook'
        link: 'https://facebook.com'
        image: 'witcher/social/facebook.svg'
      }
    ]
    menu: [
      {
        title: 'Description'
        link: '#'
      }
      {
        title: 'Trailer'
        link: '#'
      }
      {
        title: 'Reviews'
        link: '#'
      }
    ]
  main:
    genre: '2019, fantasy'
    rating: '9'
    description: "The show's first season follows Geralt of Rivia, Crown Princess Ciri, and the sorceress Yennefer of Vengerberg at different points of time, exploring formative events that shaped their characters, before eventually merging into a single timeline culminating at the battle for Sodden Hill against the invaders from Nilfgaard."
    trailer: 'https://www.youtube.com/watch?v=P0oJqfLzZzQ'
    slider: [
      {
        img: 'witcher/series/series-1.jpg'
        title: 'The End\'s Beginning'
        subtitle: 'Episode No.1'
      }
      {
        img: 'witcher/series/series-2.jpg'
        title: 'Four Marks'
        subtitle: 'Episode No.2'
      }
      {
        img: 'witcher/series/series-3.jpg'
        title: 'Betrayer Moon'
        subtitle: 'Episode No.3'
      }
      {
        img: 'witcher/series/series-4.jpg'
        title: 'Of Banquets, Bastards and Burials'
        subtitle: 'Episode No.4'
      }
    ]
  footer:
    copyright:
      year: '2021'
      movie: 'The Witcher'
    menu: [
      {
        title: 'Privacy Policy'
        link: '#'
      }
      {
        title: 'Terms of Service'
        link: '#'
      }
      {
        title: 'Legal'
        link: '#'
      }
    ]

movieConstructor '.app', movieData