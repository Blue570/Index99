extends PanelContainer


# -------------------------------------------------------------------
# Page Header
# -------------------------------------------------------------------

@onready var crawler_jobs_page_title_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageHeader/CrawlerJobsPageTitleLayout/"
	+ "CrawlerJobsPageTitleLabel"
) as Label

@onready var crawler_jobs_page_subtitle_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageHeader/CrawlerJobsPageTitleLayout/"
	+ "CrawlerJobsPageSubtitleLabel"
) as Label

@onready var crawler_jobs_page_status_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageHeader/CrawlerJobsPageStatusLabel"
) as Label


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	apply_page_theme()


func apply_page_theme() -> void:
	add_theme_stylebox_override(
		"panel",
		ThemeManager.create_page_background_style()
	)

	crawler_jobs_page_title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	crawler_jobs_page_title_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_TITLE
	)

	crawler_jobs_page_subtitle_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	crawler_jobs_page_subtitle_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	crawler_jobs_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_INFORMATION
	)
