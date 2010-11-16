module JIRA

# The base class for most of the JIRA object, most classes include an id
# attribute as a unique identifier in their area.
# @abstract
class DynamicEntity
  # @return [String] usually holds a numerical value but for consistency with
  #  with id's from custom fields this attribute is always a String
  attr_accessor :id

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @id = (frag/'id').to_s
  end
end

# Many JIRA objects include a name.
# @abstract
class NamedEntity < JIRA::DynamicEntity
  # @return [String] a plain language name
  attr_accessor :name

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    super frag
    @name = (frag/'name').to_s
  end
end

# A description would work better as a trait, but those are not supported yet.
# @abstract
class DescribedEntity < JIRA::NamedEntity
  # @return [String] usually a short blurb
  attr_accessor :description

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    super frag
    @description = (frag/'description').to_s
  end
end

# Represents a scheme used by the server. Not very useful for the sake of the
# API; a more useful case might be if you wanted to emulate the server's
# behaviour.
# @abstract
class Scheme < JIRA::DescribedEntity
  # Schemes that inherit this class will have to be careful when they try
  # to encode the scheme type in an xml message.
  # @return [String]
  def type
    self.class.to_s
  end

  # @todo remove the control couple
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    super frag unless frag
  end
end

# A common base for most issue properties. Core issue properties have
# an icon to go with them to help identify properties of issues more
# quickly.
# @abstract
class IssueProperty < JIRA::DescribedEntity
  # @return [URL] A NSURL on MacRuby and a URI::HTTP object in CRuby
  attr_accessor :icon

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    super frag
    @icon = (frag/'icon').to_url
  end
end

end